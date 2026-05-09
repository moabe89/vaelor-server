# Walkthrough — Deploy do Vaelor na VPS (Easypanel)

> **Para quem é:** Moabe — advogado, sem background técnico em Linux/Docker.
> Este walkthrough explica passo a passo como subir o Vaelor na VPS Hostinger usando o Easypanel.

---

## Pré-requisitos (você já tem)

- ✅ VPS Hostinger contratada com IP `31.97.151.29`
- ✅ Domínio `funnyotserv.com.br` apontando para o IP
- ✅ Easypanel instalado na VPS
- ✅ Repositório GitHub `moabe89/vaelor-server` (privado)
- ✅ Arquivo `.env` LOCAL com senhas geradas (NÃO está no GitHub)
- ✅ Dump do banco em `C:\ot\vaelor_db.sql`

---

## Passo 1 — Acessar o Easypanel

1. Abra o navegador e vá em `http://31.97.151.29:3000` (ou o domínio admin que você configurou)
2. Faça login com a conta admin que você criou na instalação
3. Clique em **+ New Project** → nomeie de **vaelor**

---

## Passo 2 — Adicionar o repositório GitHub privado

Como o repo é privado, o Easypanel precisa de uma "chave de acesso" (Deploy Key) ou um token.

### Opção A — Tornar público temporariamente (mais simples)
1. No GitHub: `moabe89/vaelor-server` → Settings → Change repository visibility → Public
2. Faça o deploy
3. Volte para Private depois (mas as senhas já estão no `.env`, então é seguro)

### Opção B — Personal Access Token (recomendado)
1. GitHub → Settings (foto perfil, canto direito) → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic) → marque só **`repo`** → Generate
3. Copie o token (formato `ghp_xxxxxx`)
4. No Easypanel: Settings → Source → Add GitHub Token → cole

---

## Passo 3 — Criar serviços no Easypanel

### 3.1 — Serviço **database** (MariaDB)

1. **+ Service** → **Database** → **MariaDB**
2. Nome: `database`
3. Versão: `latest`
4. **Não exponha** porta 3306 publicamente (deixe só na rede interna do projeto)
5. **Environment Variables** (cole estas, com as senhas geradas localmente):
   ```
   MYSQL_DATABASE=canary
   MYSQL_USER=canary
   MYSQL_PASSWORD=<cole aqui o MYSQL_PASSWORD do seu .env>
   MYSQL_ROOT_PASSWORD=<cole aqui o MYSQL_ROOT_PASSWORD do seu .env>
   ```
6. Volume: criar volume `db-data` montado em `/var/lib/mysql`
7. Deploy

### 3.2 — Serviço **server** (Canary)

1. **+ Service** → **App** → tipo **GitHub**
2. Conectar repo: `moabe89/vaelor-server`
3. Branch: `master`
4. Build:
   - Tipo: **Dockerfile**
   - Dockerfile path: `Dockerfile` (na raiz)
5. **Environment Variables**:
   ```
   MYSQL_HOST=database
   MYSQL_USER=canary
   MYSQL_PASSWORD=<mesmo MYSQL_PASSWORD do banco>
   MYSQL_DATABASE=canary
   ```
6. **Ports**: expor `7171` (TCP) e `7172` (TCP) publicamente
7. Deploy → vai demorar **15-30 minutos** na primeira vez (compila Canary do zero com vcpkg)

### 3.3 — Serviço **login** (login server HTTP)

1. **+ Service** → **App** → tipo **Docker Image**
2. Imagem: `opentibiabr/login-server:latest`
3. **Environment Variables**:
   ```
   MYSQL_HOST=database
   MYSQL_PORT=3306
   MYSQL_DBNAME=canary
   MYSQL_USER=canary
   MYSQL_PASS=<mesmo MYSQL_PASSWORD>
   SERVER_NAME=Vaelor
   SERVER_IP=funnyotserv.com.br
   SERVER_PORT=7172
   SERVER_LOCATION=BRA
   LOGIN_HTTP_PORT=80
   LOGIN_GRPC_PORT=9090
   ```
4. **Ports**: expor `80` publicamente (porta interna 80 do container)
5. **Domains** (Easypanel faz proxy reverso):
   - Adicionar domínio: `funnyotserv.com.br`
   - HTTPS: ON (Easypanel pega certificado SSL via Let's Encrypt automaticamente)
6. Deploy

---

## Passo 4 — Importar o banco de dados

Depois que o serviço `database` estiver rodando:

1. No Easypanel → serviço **database** → **Console** ou abrir terminal SSH na VPS
2. Copiar o `vaelor_db.sql` para a VPS:
   ```bash
   scp C:/ot/vaelor_db.sql usuario@31.97.151.29:/tmp/vaelor_db.sql
   ```
3. Importar para o container do MariaDB:
   ```bash
   docker exec -i $(docker ps -q -f name=database) mysql -u canary -p<sua_senha> canary < /tmp/vaelor_db.sql
   ```
4. **Apagar o dump da VPS depois** (segurança):
   ```bash
   rm /tmp/vaelor_db.sql
   ```

---

## Passo 5 — Validar conexão

### Do servidor (Canary)
- Logs do serviço `server` no Easypanel devem mostrar:
  ```
  >> Loading items
  >> Loading creature scripts
  ...
  >> Server Online! Up and running on Vaelor
  ```

### Do login (HTTP)
- Acesse `http://funnyotserv.com.br/login.php` no navegador
- Deve retornar JSON com info do servidor (não vai dar erro 500)

### Do cliente
- Abrir `Cliente_Vaelor.exe` (gerado pelo Inno Setup)
- IP no cliente já está pré-configurado para `funnyotserv.com.br`
- Marcar **HTTP Login** se não estiver marcado
- Login com conta de teste do dump (Account `1` / Password `1`)

---

## 🔒 Segurança — Hardening pós-deploy

Depois que estiver rodando, FAÇA:

### 1. Firewall (UFW)
Conecte na VPS via SSH e ative o firewall só nas portas necessárias:
```bash
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp     # login HTTP
sudo ufw allow 443/tcp    # HTTPS (futuro)
sudo ufw allow 7171/tcp   # canary login
sudo ufw allow 7172/tcp   # canary game
sudo ufw --force enable
sudo ufw status
```
**Não abra a porta 3306 (MariaDB)** — ele só precisa estar acessível na rede interna do Docker.

### 2. Fail2ban (anti-bruteforce SSH)
```bash
sudo apt install fail2ban -y
sudo systemctl enable --now fail2ban
```

### 3. Atualizações automáticas
```bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

### 4. Backup automático do banco
Adicione um cron job para fazer dump diário do MariaDB:
```bash
crontab -e
# Adicionar linha:
0 3 * * * docker exec $(docker ps -q -f name=database) mysqldump -u canary -p<senha> canary | gzip > /backups/vaelor_$(date +\%Y\%m\%d).sql.gz
```

### 5. Monitoramento de DDoS
- Hostinger tem proteção DDoS básica no plano (verifique no painel)
- Para proteção forte, considerar Cloudflare na frente do domínio (free tier)

---

## 🚨 Troubleshooting

### Build do canary falhou no Easypanel
- Verificar se `canary/key.pem` e `canary/schema.sql` foram pushed (sem eles, COPY do Dockerfile falha)
- Se falhar memória: VPS precisa **mínimo 4 GB RAM** para compilar canary com vcpkg

### Cliente não conecta
1. Verificar DNS: `nslookup funnyotserv.com.br 8.8.8.8` (deve retornar 31.97.151.29)
2. Verificar porta 7172 aberta: `telnet funnyotserv.com.br 7172`
3. Verificar logs do server no Easypanel

### Login HTTP retorna 500
- Geralmente é falta de conexão com o banco
- Verificar variáveis de ambiente do serviço `login` (mesma senha do banco)

### Senha esquecida
- O `.env` LOCAL no seu PC tem as senhas
- Se perder o `.env` local, conecta na VPS via SSH e olha as env vars do container Docker

---

## Próximas fases (depois do deploy online)

- **Fase 4 — Customização Sandbox**: rates altas, itens infinitos, scripts conveniência (lua-game-scripter)
- **Fase 5 — Mapa custom Vaelor**: editar com RME (Remere's Map Editor)
- **Fase 8 — Divulgação e Launch**: AAC web (myAAC), divulgação em foruns

---

*Escrito por Claude Code (Sonnet 4.6) em 2026-05-09 — primeiro deploy do Vaelor.*
