# Vaelor — STATUS atual

**Snapshot:** 2026-05-09 (Auditoria de seguranca + correcoes pre-deploy)

## Resumo do Progresso
- ✅ Servidor versionado no GitHub (`moabe89/vaelor-server` PRIVADO)
- ✅ Configuracao VPS pronta (Dockerfile multi-stage + docker-compose)
- ✅ Cliente OTClient v4.0 configurado para `funnyotserv.com.br`
- ✅ Minimap revelado integrado ao instalador (Inno Setup)
- ✅ Dump do banco exportado (`vaelor_db.sql`)
- ✅ DNS funcionando (Google DNS resolve, ping OK no IP 31.97.151.29)

**Auditoria 2026-05-09 (sessao Claude Code Sonnet 4.6):**
- 🔴 **Resolvido:** `.gitignore` estava bloqueando `key.pem` e `schema.sql` (build na VPS iria falhar)
- 🔴 **Resolvido:** Senhas movidas do docker-compose.yml para `.env` (gerado com `openssl rand -base64`)
- 🔴 **Resolvido:** MariaDB nao mais exposto na internet (porta 3306 so na rede interna do Docker)
- 🟠 **Resolvido:** Login server agora usa porta 8080 (evita conflito com nginx-proxy do Easypanel)
- 🟢 **Criado:** `walkthrough.md` com passo-a-passo do deploy no Easypanel
- 🟢 **Criado:** `.env.example` (template publico) e `.env` (local, sem secrets no git)

## Componentes

| Componente | Estado | Localizacao | Notas |
|---|---|---|---|
| **Engine Canary** | ✅ Versionado + Hardening | [GitHub Repo](https://github.com/moabe89/vaelor-server) | Dockerfile + docker-compose com .env |
| **Banco de Dados** | ✅ Exportado | `C:\ot\vaelor_db.sql` | Importar via `docker exec` na VPS |
| **Dominio** | ✅ Funcionando | `funnyotserv.com.br` | Resolve para `31.97.151.29`, ping 17ms |
| **OTClient v4.0** | ✅ Configurado | `C:\ot\cliente_4.0\` | Apontando para o dominio + minimap revelado |
| **Instalador** | ✅ Script Pronto | `C:\ot\Vaelor_Install.iss` | Pronto para gerar `Instalador_Vaelor.exe` |
| **Cliente Final** | ✅ Empacotado | `C:\ot\Cliente_Vaelor.zip` (1.76 GB) | Pronto para distribuir |
| **Walkthrough** | ✅ Escrito | `C:\ot\walkthrough.md` | Passo-a-passo Easypanel |
| **VPS (Easypanel)** | 🔄 Aguardando | `31.97.151.29` | Servicos pendentes (database, server, login) |

## Mapas — esclarecimento

- **Mapa do mundo (servidor):** `data-otservbr-global/world/otservbr.otbm` (184 MB) — **NAO vai pro git** (ignorado pelo gitignore por tamanho). O Canary baixa automaticamente do release oficial OpenTibiaBR no primeiro start (`mapDownloadUrl` no config.lua).
- **Minimap revelado (cliente):** `cliente_4.0/data/minimap/*.png` (13 MB) — **NAO vai pro git** (cliente_4.0 ignorado). Distribuido via instalador Inno Setup, copiado para `%appdata%\otcr\otclient\otclient\minimap\` quando o jogador instala.
- **Conclusao:** os "mapas abertos" (minimap revelado) JA ESTAO solucionados — vao com o instalador, nao com o git.

## Seguranca

### O que ja esta protegido
- ✅ Senhas das contas com Argon2 (memoryConst 1<<16, parallelism 2)
- ✅ Anti-flood: `maxPacketsPerSecond = 25`
- ✅ Anti-multiclient: `maxPlayersOnlinePerAccount = 1`
- ✅ Anti-AFK: `kickIdlePlayerAfterMinutes = 15`
- ✅ Anti-reload em producao: `allowReload = false`
- ✅ MariaDB nao exposto na internet (so rede Docker)
- ✅ Senhas geradas com openssl (32 chars aleatorios) no `.env` local
- ✅ Repositorio GitHub PRIVADO

### Pendencias de seguranca (pos-deploy, no walkthrough)
- 🔄 Ativar UFW (firewall) na VPS — so portas 22, 80, 443, 7171, 7172
- 🔄 Instalar fail2ban (anti-bruteforce SSH)
- 🔄 Ativar unattended-upgrades (patches automaticos do Linux)
- 🔄 Cron job para backup diario do MariaDB
- 🔄 Considerar Cloudflare na frente do dominio (anti-DDoS gratuito)

## Proximas Acoes

1. **Push para GitHub** — sincronizar correcoes de gitignore, docker-compose, walkthrough, STATUS
2. **Subir servicos no Easypanel** — seguir `walkthrough.md`
3. **Importar `vaelor_db.sql`** no MariaDB da VPS
4. **Compilar Instalador** — usar Inno Setup local
5. **Validar conexao** — `funnyotserv.com.br` + login com Account `1` / Password `1`
6. **Hardening pos-deploy** — firewall, fail2ban, backups (passo 5 do walkthrough)

## Roadmap

- ✅ Fases 1-6 — Local Dev Completo
- ✅ Fase 7a — Versionamento + Configuracao Docker (concluido)
- 🔄 Fase 7b — Deploy ativo na VPS (proxima sessao)
- ⏳ Fase 8 — Divulgacao e Launch

---
*Atualizado por Claude Code Sonnet 4.6 em 2026-05-09 — pos-auditoria de seguranca.*
