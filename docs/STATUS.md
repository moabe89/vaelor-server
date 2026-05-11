# FunnyOt — STATUS atual

**Snapshot:** 2026-05-11 (sessao Claude Code Opus 4.7 — migracao para Mac)

---

## 🟢 ESTADO ATUAL (FUNCIONANDO)

### Servidor VPS
- VPS Hostinger Ubuntu 24.04 (`31.97.151.29`)
- 3 containers Docker rodando via `/opt/vaelor/docker-compose.yml`:
  - `vaelor-database-1` (MariaDB) — Healthy (em 2 redes: vaelor_default + easypanel)
  - `vaelor-server-1` (Canary 3.4.2) — game online, porta 7172
  - `vaelor-aac-1` (myAAC PHP/Apache) — porta 8081, ativo
- SSH funcionando com chave ed25519 em `~/.ssh/id_ed25519`

### Cliente
- **Cliente_5.0** funcionando: `c:/ot/cliente_5.0/`
- Cliente Mehah Redemption 4.0 hotfix(1) (OpenTibiaBR oficial)
- Binarios DirectX (otclient.exe) e OpenGL (otclient_opengl.exe)
- Mapa otservbr aberto via `game_mapimporter` + 1069 PNGs `Minimap_Color_*` em `data/images/game/`
- Login HTTP funcionando

### Empacotamento (pronto para distribuir)
- `c:/ot/FunnyOt-Setup.exe` (152MB) — instalador Inno Setup com icone do Tibia
- `c:/ot/FunnyOt-Client.zip` (160MB) — ZIP alternativo
- `c:/ot/FunnyOt-LEIA-ME.txt` — instrucoes para usuarios
- `c:/ot/FunnyOt-Setup.iss` — script Inno Setup (regenera o .exe)

### Conta admin
- **name:** `god` | **email:** `@god` | **senha:** `5189Mob538` (SHA1 no banco)
- ⚠️ Senha antiga `god` foi REVOGADA
- Conta secundaria admin: `moabeas` (email `moabe.a.sousa@gmail.com`)

### Easypanel - configuracao quase pronta
- Painel: http://31.97.151.29:3000/ (login do Moabe)
- Projeto: `valeor` (nao foi renomeado para `funnyot`, pois Easypanel nao tem essa opcao - nome interno apenas)
- Servico: `aac`
  - Fonte: GitHub `moabe89/vaelor-server` ramo `master`
  - Construcao: Dockerfile `Dockerfile.aac`
  - Variaveis de ambiente: configuradas (ver abaixo)
  - Dominios: 
    - `https://valeor-aac.0qcyoj.easypanel.host/` (gratis, ja ativo)
    - `https://funnyotserv.com.br/` (aguarda DNS propagar)
- MariaDB conectado a rede `easypanel` via `docker network connect easypanel vaelor-database-1`

### Variaveis de ambiente do aac no Easypanel
```
MYSQL_HOST=vaelor-database-1
MYSQL_USER=canary
MYSQL_PASSWORD=yQHznOx7QODicXnxEpY8JUD17oJeNrGG
MYSQL_DATABASE=canary
SERVER_NAME=FunnyOt
SERVER_URL=https://funnyotserv.com.br/
SERVER_IP=31.97.151.29
```

---

## ⏳ PRÓXIMOS PASSOS (RETOMAR NO MAC)

### 1. Clicar em "Implantar" no Easypanel
- Acessar painel http://31.97.151.29:3000/
- Projeto valeor > aac
- Botao verde "Implantar"
- Acompanhar logs (deve dar erro de Let's Encrypt no inicio - normal, esperar DNS)

### 2. DNS no registro.br
- Em ~2h apos 2026-05-11 17:00 BRT, dominio funnyotserv.com.br libera para configurar
- Adicionar 2 registros A:
  - `@` → `31.97.151.29`
  - `www` → `31.97.151.29`
- Easypanel + Let's Encrypt ativam HTTPS automaticamente quando DNS propagar

### 3. Validar HTTPS funcionando
- Testar `https://funnyotserv.com.br/` no browser
- Deve aparecer cadeado verde
- Pagina deve mostrar myAAC com tema "kathrine" ainda (template feio mas funcional)

### 4. Desligar aac antigo (apos confirmar novo OK)
```bash
ssh root@31.97.151.29
cd /opt/vaelor
docker compose stop aac
docker compose rm -f aac
```
- Cuidado: NAO desligar database nem server, apenas o aac antigo

### 5. Trocar template do myAAC (Kathrine → tibiacom)
- Acessar https://funnyotserv.com.br/admin (ou via DB)
- Mudar template para "tibiacom" (visual oficial do Tibia)
- Templates disponiveis no container aac: `/var/www/html/templates/`

### 6. Investigar "Server Offline" no site
- O myAAC mostra "Server Offline" no canto direito mesmo com canary online
- Provavelmente porta de status errada no config
- Verificar `statusProtocolPort` no config.lua gerado

---

## 📁 ARQUIVOS IMPORTANTES

### No PC Windows (c:/ot/)
- `Dockerfile.aac` — build do container myAAC
- `aac/docker-entrypoint.sh` — gera config.lua dinamicamente
- `docker-compose.yml` — config dos 3 containers
- `.env` (LOCAL, nao commitado) — credenciais MySQL
- `canary/` — source do servidor C++ (nao mexer mais)
- `cliente_5.0_dist/` — pasta limpa para empacotar
- `FunnyOt-Setup.exe`, `FunnyOt-Client.zip` — pacotes finais
- `FunnyOt-Setup.iss` — script Inno Setup

### Na VPS (/opt/vaelor/)
- `docker-compose.yml` — clone do GitHub
- `.env` — credenciais (com SERVER_NAME=FunnyOt, SERVER_IP=31.97.151.29)

### Conta GitHub
- Repo: https://github.com/moabe89/vaelor-server
- Branch: `master`
- Ultimo commit relevante: `c8c58c0 Fix: externaladdress do myAAC...`

---

## 🔑 SENHAS E CREDENCIAIS (.env LOCAL, NAO COMMITADO)

```
# MySQL
MYSQL_USER=canary
MYSQL_PASSWORD=yQHznOx7QODicXnxEpY8JUD17oJeNrGG
MYSQL_ROOT_PASSWORD=M74xQR4zH8YRoRP8C8dgx3vN87Y2r5MB
MYSQL_DATABASE=canary

# Server
SERVER_NAME=FunnyOt
SERVER_PORT=7172
SERVER_IP=31.97.151.29
SERVER_LOCATION=BRA
```

### Conta admin do jogo
- Account: `@god` | Password: `5189Mob538`

### SSH VPS
- `ssh root@31.97.151.29` (chave ed25519 ja autorizada no PC Windows)
- No Mac: precisa copiar a chave ou gerar nova

---

## 🛠️ COMANDOS UTEIS

### Ver status dos containers
```bash
ssh root@31.97.151.29 'cd /opt/vaelor && docker compose ps'
```

### Ver logs do aac (web)
```bash
ssh root@31.97.151.29 'cd /opt/vaelor && docker compose logs --tail=30 aac'
```

### Ver logs do servidor canary
```bash
ssh root@31.97.151.29 'cd /opt/vaelor && docker compose logs --tail=30 server'
```

### Testar login HTTP
```bash
curl -s -X POST -H 'Content-Type: application/json' \
  -d '{"email":"@god","password":"5189Mob538","stayloggedin":true,"type":"login"}' \
  http://31.97.151.29:8081/login.php | head -c 200
```

### Acessar database
```bash
ssh root@31.97.151.29 'cd /opt/vaelor && docker compose exec database \
  mariadb -ucanary -pyQHznOx7QODicXnxEpY8JUD17oJeNrGG canary -e "SELECT * FROM accounts;"'
```

### Renovar imagem do cliente (recompila com Inno Setup)
```powershell
& "C:/Users/Meu-PC/AppData/Local/Programs/Inno Setup 6/ISCC.exe" "c:/ot/FunnyOt-Setup.iss"
```

---

## 📦 HISTORICO DE DECISOES (sessao Opus 4.7)

| Decisao | Justificativa |
|---|---|
| Cliente Mehah 4.0 oficial (vs build custom) | Build custom tinha multiplos bugs acumulados |
| Manter projeto Easypanel chamado `valeor` (interno) | Easypanel nao tem rename; nome interno apenas, nao aparece para usuario |
| Distribuir tanto `.exe` quanto `.zip` | Flexibilidade para usuarios diferentes |
| Senha @god trocada para forte | Default `god/god` e conhecido por todos |
| Mapa aberto via PNGs + game_mapimporter | Solucao usada anteriormente, comprovada |
| Conectar database a rede `easypanel` (vs migrar) | Menos risco, evita reimportar dados |

---

*Atualizado por Claude Code Opus 4.7 em 2026-05-11 — sessao migrando para Mac.*
