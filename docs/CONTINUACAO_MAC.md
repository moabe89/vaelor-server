# Continuacao no Mac — Sessao 2026-05-11

## Cenario

Voce (proximo agente Claude) vai continuar o deploy do servidor **FunnyOt** (antes chamado Vaelor) na VPS Hostinger. O projeto esta 90% pronto — falta apenas finalizar a migracao do aac para Easypanel com HTTPS.

## PRIMEIRA AÇÃO (faça isso antes de qualquer outra coisa)

1. Leia `docs/STATUS.md` por completo (snapshot do estado atual)
2. Leia `CLAUDE.md` (identidade e missao do agente)
3. Confirme acesso SSH a VPS: `ssh root@31.97.151.29 'docker ps | head'`
4. Confirme que o site antigo ainda esta acessivel: `curl -sI http://31.97.151.29:8081/`

---

## SETUP no Mac

### 1. Chave SSH

A chave que usavamos no Windows estava em `C:/Users/Meu-PC/.ssh/id_ed25519`. No Mac voce tem 2 opcoes:

**Opcao A — Copiar a chave do Windows (mais rapido):**
- No Windows, copie os arquivos `id_ed25519` e `id_ed25519.pub` da pasta `.ssh` para algum lugar acessivel (Dropbox/OneDrive/pendrive)
- No Mac, salve em `~/.ssh/id_ed25519` (sem extensao)
- Ajuste permissao: `chmod 600 ~/.ssh/id_ed25519`
- Teste: `ssh root@31.97.151.29 hostname`

**Opcao B — Gerar nova chave Mac:**
```bash
ssh-keygen -t ed25519 -C "moabe.a.sousa@gmail.com"
cat ~/.ssh/id_ed25519.pub  # copia esta linha
```
Depois acessar via console Hostinger ou Easypanel terminal, e adicionar essa nova chave em `/root/.ssh/authorized_keys` da VPS.

### 2. Repositorio

O codigo esta tanto no GitHub quanto no OneDrive sincronizado:

```bash
# Opcao 1 - clonar do GitHub:
cd ~/
git clone https://github.com/moabe89/vaelor-server.git ot
cd ot

# Opcao 2 - usar OneDrive sincronizado (ja deve estar la):
cd ~/Library/CloudStorage/OneDrive-Personal/ot
# ou onde o OneDrive sincroniza no Mac
```

### 3. .env (NAO esta no Git, voce precisa criar)

Crie `.env` na raiz do projeto:

```env
MYSQL_USER=canary
MYSQL_PASSWORD=yQHznOx7QODicXnxEpY8JUD17oJeNrGG
MYSQL_ROOT_PASSWORD=M74xQR4zH8YRoRP8C8dgx3vN87Y2r5MB
MYSQL_DATABASE=canary

SERVER_NAME=FunnyOt
SERVER_PORT=7172
SERVER_IP=31.97.151.29
SERVER_LOCATION=BRA
```

---

## CONTEXTO DO QUE FALTA FAZER

### Status no momento de pausa
- ✅ VPS rodando, jogadores podem entrar via cliente em `http://31.97.151.29:8081/`
- ✅ Cliente empacotado (FunnyOt-Setup.exe + FunnyOt-Client.zip)
- ✅ Easypanel configurado com servico `aac`:
  - Fonte GitHub OK
  - Build Dockerfile.aac OK
  - Variaveis ambiente OK
  - Dominios adicionados (mas funnyotserv.com.br aguarda DNS)
- ⏳ **NAO FOI CLICADO O BOTAO "IMPLANTAR" AINDA**
- ⏳ DNS funnyotserv.com.br em transicao no registro.br (liberado ~2h apos 17:00 BRT 2026-05-11)

### Sequencia para retomar:

#### Passo A — Verificar se DNS propagou
```bash
# No Mac terminal:
dig +short funnyotserv.com.br

# Deve retornar 31.97.151.29
# Se nao retornar nada, ainda nao propagou
```

Se nao propagou:
- Entrar no painel registro.br (https://registro.br)
- Domain `funnyotserv.com.br` > DNS > Adicionar registros tipo A:
  - `@` → 31.97.151.29
  - `www` → 31.97.151.29

#### Passo B — Implantar no Easypanel
- Acessar http://31.97.151.29:3000/ (login do Moabe)
- Projeto `valeor` > Servico `aac`
- Botao verde "Implantar"
- Aguardar build (vai puxar do GitHub, builda Dockerfile.aac, deploya)
- Ver logs em tempo real

Possiveis erros:
- "Cannot connect to MySQL" → o container do aac precisa estar na rede `easypanel` (ja conectamos `vaelor-database-1` la mas o aac novo tambem precisa conectar via DNS)
- Verificar: `ssh root@31.97.151.29 'docker network inspect easypanel | grep -A2 vaelor-database'`

#### Passo C — Validar site novo
```bash
# Testar dominio Easypanel gratis (ja funciona sem DNS proprio)
curl -sI https://valeor-aac.0qcyoj.easypanel.host/

# Testar dominio proprio (apos DNS)
curl -sI https://funnyotserv.com.br/
```

Ambos devem retornar `HTTP/2 200`.

#### Passo D — Desligar aac antigo (somente apos validar novo)
```bash
ssh root@31.97.151.29
cd /opt/vaelor
docker compose stop aac
docker compose rm -f aac
```

⚠️ NAO desligue database nem server (canary)!

#### Passo E — Bonus
- Trocar template myAAC para `tibiacom` (visual oficial)
- Investigar "Server Offline" no canto da pagina (problema de status check)
- Considerar configurar UFW firewall + fail2ban (hardening)

---

## ULTIMO ESTADO CONFIRMADO

- **Cliente:** Login funciona com `@god` / `5189Mob538`. Mapa abre completo. Personagens Sample disponíveis.
- **Empacotamento:** FunnyOt-Setup.exe testado pelo Moabe e funciona.
- **Site:** http://31.97.151.29:8081/ acessivel publicamente. Mostra "FunnyOt" no titulo (Vaelor → FunnyOt ja migrado).
- **Easypanel:** Servico aac criado e configurado. So falta clicar Implantar.

---

## CONTATO COM O USUARIO

Moabe e advogado, nao programador. Use linguagem leiga. Analogias antes de termos tecnicos. Confirme antes de acoes destrutivas. Termometro de risco visivel.

---

*Atualizado por Claude Code Opus 4.7 em 2026-05-11.*
