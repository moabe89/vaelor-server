# Vaelor — STATUS atual

**Snapshot:** 2026-05-09 (Migração para VPS e Deploy Online)

## Resumo do Progresso
Nesta sessão, preparamos o servidor para o deploy online na VPS (Easypanel). O código foi versionado no GitHub, o banco de dados foi exportado e o cliente foi configurado para o domínio final `funnyotserv.com.br`. Também integramos o minimap revelado e os marcadores diretamente no instalador.

## Componentes

| Componente | Estado | Localização | Notas |
|---|---|---|---|
| **Engine Canary (v3.4.0)** | ✅ Versionado | [GitHub Repo](https://github.com/moabe89/vaelor-server) | Dockerfile e docker-compose.yml prontos para deploy na VPS. |
| **Banco de Dados (SQL)** | ✅ Exportado | `C:\ot\vaelor_db.sql` | Pronto para importação no MariaDB da VPS. |
| **Domínio** | ✅ Comprado | `funnyotserv.com.br` | Apontamento para o IP `31.97.151.29` pendente/em propagação. |
| **OTClient (v4.0)** | ✅ Configurado | `C:\ot\cliente_4.0\` | Apontando para o domínio global. Minimap revelado incluído em `data/minimap`. |
| **Instalador** | ✅ Script Pronto | `C:\ot\Vaelor_Install.iss` | Configurado para instalar cliente + minimap no Roaming do jogador. |
| **VPS (Easypanel)** | 🔄 Em Progresso | `31.97.151.29` | Aguardando criação dos serviços (App, Database, Login). |

## Modificações Recentes
- **config.lua:** IP alterado para `0.0.0.0` (Docker), nome "Vaelor", URLs apontando para o domínio.
- **init.lua (Cliente):** IPs de login e site alterados para `funnyotserv.com.br`.
- **Docker:** Criado `Dockerfile` multi-stage para compilar o Canary sem dependência de NuGet externo.
- **Minimap:** Arquivos de mapa aberto e marcadores (`minimap.otmm`) integrados ao pacote de instalação.

## Próximas Ações (Para o Claude Code / Próximo PC)

1. **Importar Banco:** Subir `vaelor_db.sql` no phpMyAdmin do Easypanel.
2. **Deploy na VPS:** Criar os serviços (MariaDB, App Canary, Login Server) no Easypanel seguindo o `walkthrough.md`.
3. **Compilar Instalador:** Usar o Inno Setup para gerar o `Instalador_Vaelor.exe` final.
4. **Validar Conexão:** Testar login via `funnyotserv.com.br` assim que o DNS propagar.

## Roadmap atualizado
- ✅ Fases 1 a 6 — Local Dev Completo.
- 🔄 Fase 7 — Deploy VPS e Domínio (Em andamento).
- ⏳ Fase 8 — Divulgação e Launch.

---
*Atualizado por Antigravity em 2026-05-09.*
