# FunnyOt — STATUS do projeto

**Última atualização:** 2026-05-13 (sessão noite)
**Branch:** master, último commit `75f9631`

## 🟢 Estado geral: PRODUÇÃO funcional

| Camada | Status |
|---|---|
| Servidor Canary (porta 7172) | ✅ Up, online |
| Site myAAC HTTPS | ✅ https://funnyotserv.com.br/ (Let's Encrypt) |
| Domínio | ✅ DNS configurado no registro.br |
| Cliente Mehah | ✅ Funciona com HTTPS funnyotserv.com.br:443 |
| Download do cliente | ✅ https://funnyotserv.com.br/files/FunnyOt-Setup.exe |

## 📊 Rates ativas (sandbox)

| Rate | Valor |
|---|---|
| Exp stages | 150x/75x/50x/25x (por faixa de level) |
| Skill stages | 30x/15x |
| Magic stages | 20x/10x |
| Loot | 4x |
| Attack speed | 1200ms (-40% do original 2000ms) |
| Cooldown spells | -40% do original |
| Stamina | infinita (sempre 42:00 verde) |
| Itens infinitos | potions, runas, ammo |
| Premium | true para TODOS |

## 🎮 Features sandbox

### Comandos `!` (players)
`!mounts`, `!outfits`, `!blessings`, `!preyslot`, `!runes`, `!autoloot on/off`

### Comandos `/` (god — só conta `god` e `moabeas`)
`/i`, `/m`, `/goto`, `/addmount`, `/addskill`, etc. (todos os GOD do canary)

### Sistemas custom
- **Funny Trader**: NPC vendedor em 25 cidades
- **Sala de TPs**: 28 destinos (POI, Anni, Demon Helmet, Demon Oak, Soul War, Heart of Destruction, Orc Fortress, Liches, Hydras, Demons, Drakens, Vampires, etc.) — ⚠️ visual quebrado, ver pendências
- **Auto-conversão de moedas**: clicar em 100+ gold = 1 platinum (sem precisar de Gold Converter)
- **Bonus level 20**: 40k gold ao subir pra nível 20
- **Auto-target waves/beams**: 13 spells direcionais detectam target marcado e saem na direção sem rotacionar player
- **Starter kit**: char novo recebe exercise weapons compatíveis com sua vocação

### Exercise weapons (sandbox)
- SKILL_MULTIPLIER = 15 (skill x15 por tick)
- CHARGES_PER_TICK = 15 (consome 15 charges por tick)
- Tick interval: ~1.2s (baseado em vocation:getBaseAttackSpeed())
- Lasting Sword (14400 charges) dura ~19min de treino contínuo
- Skill por minuto: ~5250 (vs 350 do Tibia oficial)

## 📁 Estrutura do projeto

```
c:/ot/
├── canary/                  # source do servidor (Lua + C++ + XML)
│   ├── config.lua           # ⭐ todas as configs
│   ├── data/                # scripts core canary
│   ├── data-otservbr-global/ # scripts específicos otservbr
│   └── ...
├── aac/                     # source myAAC (PHP/Twig)
│   └── templates/funnyot/   # template visual oficial
├── cliente_5.0/             # source do cliente Mehah (Lua + C++)
├── cliente_5.0_dist/        # dist do cliente (pacote pra instalador)
├── Dockerfile               # canary game (Linux/VPS)
├── Dockerfile.aac           # myAAC (PHP/Apache)
├── docker-compose.yml       # database + server (aac antigo desativado)
├── FunnyOt-Setup.iss        # Inno Setup do instalador
├── FunnyOt-Setup.exe        # ✅ instalador atual
└── docs/STATUS.md           # este arquivo
```

## 🌐 Infra VPS (Hostinger)

- **IP**: 31.97.151.29 (Ubuntu 24.04)
- **SSH**: `ssh root@31.97.151.29` (chave ed25519)
- **Easypanel**: http://31.97.151.29:3000/
- **Containers ativos:**
  - `vaelor-database-1` (MariaDB)
  - `vaelor-server-1` (Canary)
  - `valeor_aac.1.xxx` (myAAC via Easypanel — serve site HTTPS)
  - `traefik.1.xxx` (reverse proxy do Easypanel)

## 🔧 Como aplicar mudanças

### Mudanças em scripts Lua do canary
1. Edita arquivo em `c:/ot/canary/data/` ou `data-otservbr-global/`
2. `scp` pro VPS `/tmp/`
3. `docker cp` pro container `vaelor-server-1`
4. `docker compose restart server`

### Mudanças no template myAAC
1. Edita arquivo em `c:/ot/aac/templates/funnyot/`
2. `scp` + `docker cp` pro container `valeor_aac.*`
3. `apache2ctl -k graceful` + limpar cache

### Mudanças no cliente Mehah
1. Edita `cliente_5.0/init.lua` ou módulos
2. Sincronizar pro `cliente_5.0_dist/`
3. Inno Setup → recompila `FunnyOt-Setup.exe`
4. Upload pro `/var/www/html/files/` no container valeor_aac

## ⚠️ Pendências pra próxima sessão

Ver memórias em `.claude/projects/c--ot/memory/`:
- `pendencia_sala_tps_visual.md` — sala TPs com campos pretos, falta plaquinhas individuais
- `pendencia_forge_e_store.md` — Exaltation Forge mostra placeholders literais + Store ingame com `?` em todas categorias
- `project_pendencias_sandbox.md` — visão geral

## 📝 Decisões importantes

- **freePremium = true** — todos jogam com premium
- **autoLoot = true** — todos podem usar `!autoloot on`
- **Account types**: só `god` e `moabeas` são type=6 (GOD). Outras contas type=1 (NORMAL) — não usam comandos `/`
- **Tokens Mount/Outfit**: REMOVIDOS por enquanto (reusavam items existentes que monstros dropam)
- **Sala de TPs**: implementada via Lua spawn (sem mexer no .otbm) — segura mas visual ruim
- **Exercise weapons** rejeitou hiper-fast (skill x30 + tick 0.5s), voltou para x15 + 1.2s

---

*Atualizado por Claude Code Opus 4.7 em 2026-05-13 noite — antes do /compact.*
