# Vaelor — STATUS atual

**Snapshot:** 2026-05-09 (final da sessao Claude Code Sonnet 4.6 — migracao para Mac)

## ESTADO ATUAL DO DEPLOY VPS

### ✅ FUNCIONANDO
- VPS Hostinger Ubuntu 24.04 (`31.97.151.29`) com Docker rodando
- SSH com chave ed25519 (chave em `~/.ssh/id_ed25519` no PC Windows)
- 3 containers Docker rodando:
  - `vaelor-database-1` (MariaDB) — Healthy
  - `vaelor-server-1` (Canary 3.4.2) — Up, com mapa otservbr.otbm carregado
  - `vaelor-aac-1` (myAAC PHP/Apache) — Started, mas com erro 500 ao logar
- Banco com **68 tabelas** importadas (canary + myaac_*)
- Mapa otservbr.otbm baixado e carregado no canary (~~Server Online! Up and running on Vaelor~~)
- Login HTTP testado via curl: `@god/god` retorna lista de personagens com login server OTBR (mas era o errado)

### 🔴 BLOQUEIO ATIVO — myAAC retorna HTTP 500 vazio
- Login direto via curl em `http://127.0.0.1:8081/login.php` retorna `HTTP/1.0 500 Internal Server Error` com `Content-Length: 0`
- Tabelas myaac_* ja foram importadas via root user (resolveu erro de TRIGGER privilege)
- Apos restart do container `aac`, ainda retorna 500
- **Proximo passo:** rodar `docker compose logs --tail=50 aac` para ver qual erro PHP esta acontecendo agora

## CONTEXTO PARA CONTINUAR (PROXIMA SESSAO)

### Senhas no .env LOCAL (NAO COMMITADO)
Arquivo `.env` na raiz do projeto com:
```
MYSQL_USER=canary
MYSQL_PASSWORD=yQHznOx7QODicXnxEpY8JUD17oJeNrGG
MYSQL_ROOT_PASSWORD=M74xQR4zH8YRoRP8C8dgx3vN87Y2r5MB
MYSQL_DATABASE=canary
```

⚠️ AO MIGRAR PARA O MAC: copie o `.env` junto (esta no .gitignore, NAO vai pelo GitHub).

### Conta admin do banco
- name=`god`, email=`@god`, password=`god` (SHA1 confirmado)
- name=`moabeas`, email=`moabe.a.sousa@gmail.com`, password=desconhecida (criada pelo myAAC com Argon2)

### Login HTTP — protocolo
O canary OpenTibiaBR REJEITA TCP login no port 7171 quando protocolo >= 1281 (Tibia 12+).
Mensagem do canary: "Only protocol version 15.00 or outdated 11.00 is allowed."
Por isso DEVE-SE usar HTTP login via myAAC.

### Cliente OTClient — modificacoes feitas
1. `cliente_4.0/init.lua` configurado para HTTP login em `31.97.151.29:8081/login.php`
2. `cliente_4.0/modules/gamelib/protocollogin.lua` linha 98 — bloco `GameOGLInformation` desabilitado (`if false and ...`) — canary nao espera info de GPU/Renderer no pacote de login
3. `%APPDATA%/otcr/otclient/otclient/config.otml` host atualizado para `31.97.151.29:8081/login.php`

### Arquitetura Docker (docker-compose.yml)
- `database` (mariadb:latest) — porta interna 3306
- `aac` (build Dockerfile.aac) — porta 8081:80, gera config.lua dinamicamente via entrypoint
- `server` (build Dockerfile) — portas 7171 e 7172 expostas
- Volume: `db-data` para MariaDB persistir

### Servicos OUTROS na VPS (nao mexer)
- evolution-api (n8n) — porta 8080
- traefik (Easypanel) — portas 80, 443
- postgres + redis (n8n) — portas 5432, 6379
- easypanel — porta 3000

## TODOs PROXIMA SESSAO

1. **Diagnosticar erro 500 no myAAC** — rodar `docker compose logs --tail=80 aac | grep -iE "error|fatal"` para ver erro PHP atual
2. Possivel causa: cache do myAAC com referencia a path antigo, ou config.local.php ainda apontando errado
3. Apos myAAC funcionar via curl, testar login no cliente OTClient
4. **DNS:** dominio `funnyotserv.com.br` resolve via Google DNS mas DNS local do PC nao propagou. Apontar registro A para 31.97.151.29 no painel Hostinger se quiser usar dominio.
5. **Hardening seguranca pos-login funcionar:**
   - UFW firewall (so portas 22, 80, 443, 7171, 7172, 8081)
   - fail2ban anti-bruteforce SSH
   - unattended-upgrades patches Linux
   - Cron diario backup MariaDB
6. Reverter logLevel do canary de "info" (que ja esta), nao precisa mexer

## ARQUIVOS IMPORTANTES MODIFICADOS NESTA SESSAO

| Arquivo | O que mudou |
|---|---|
| `.gitignore` | excecoes para canary/key.pem e canary/schema.sql |
| `Dockerfile` | adicionou ca-certificates |
| `Dockerfile.aac` | NOVO — build PHP-Apache + extensoes para myAAC |
| `aac/` | NOVO — copia do myAAC do XAMPP local (`C:/xampp/htdocs/`) |
| `aac/config.local.php` | server_path=/canary/, site_url=http://31.97.151.29:8081/ |
| `aac/docker-entrypoint.sh` | NOVO — gera config.lua dinamicamente das env vars |
| `docker-compose.yml` | substituiu OTBR Login Server por myAAC, ajustou portas |
| `cliente_4.0/init.lua` | HTTP login em 31.97.151.29:8081/login.php |
| `cliente_4.0/modules/gamelib/protocollogin.lua` | desabilitou GameOGLInformation (linha ~98) |
| `walkthrough.md` | passo-a-passo Easypanel + hardening |

## COMMITS DESTA SESSAO

```
a61465e Fix myAAC: gera config.lua dinamicamente via entrypoint (resolve os.getenv issue)
2ec75cf Substitui OTBR Login Server por myAAC (compatibilidade com cliente Vaelor)
6e052cc Reativa login server (porta 8081) para HTTP login
f3989f1 Deploy VPS: comenta login server temporariamente (conflito de porta com Traefik/Easypanel)
f23c017 Adiciona ca-certificates no Dockerfile (fix download HTTPS)
425c80c Auditoria seguranca + corrige .gitignore que bloqueava build na VPS
```

---
*Atualizado por Claude Code Sonnet 4.6 em 2026-05-09 — sessao migrando para Mac.*
