# Projeto Vaelor — OTServer Tibia 15.x

Servidor privado de Tibia (OpenTibia) protocolo 15.x rodando engine Canary (OpenTibiaBR) e cliente OTClient Mehah DX11. Modo sandbox/solo.

## Estrutura

```
C:\ot\
├── canary\           # Engine (Canary) compilada — canary.exe
├── cliente_1524\     # Cliente (OTClient Mehah DX11) — otclient_dx_x64.exe
├── vcpkg\            # Gerenciador de pacotes C++ (deps Boost, LuaJIT, etc.)
├── Outros docs\      # Roadmap + Relatório + installers (XAMPP, OTClient zips)
├── docs\             # Documentação operacional do agente Vaelor
├── .claude\          # Agente Claude Code (sub-agents, skills, commands)
├── .gemini\          # Agente Antigravity/Gemini (mirror)
├── CLAUDE.md         # Cérebro do agente (Claude)
├── GEMINI.md         # Mirror Antigravity
├── AGENTS.md         # Índice universal
├── .mcp.json         # MCPs (github, context7, filesystem, memory)
└── .gitignore
```

## Como usar o agente

### Claude Code
1. Abra Claude Code (CLI ou VS Code) na pasta `C:\ot\`
2. Cole o prompt de `docs/PRIMEIRO_CONTATO.md`
3. O agente lê CLAUDE.md, faz smoke check e sugere próximo passo

### Antigravity (Gemini)
1. Abra Antigravity em `C:\ot\`
2. Cole o mesmo prompt
3. O agente lê GEMINI.md e segue o mesmo fluxo

## Estado atual (2026-05-08)

- ✅ Canary compilado
- ✅ OTClient extraído com source completo
- ✅ Assets 15.24 importados
- ❌ Cliente não abre — erro de versão (Mehah Redemption 4.x suporta até 1511, assets são 1524)

Próximo passo: rodar skill `diagnose-otclient-startup` ou comando `/diagnose-startup`.

## Documentos de referência

- `Outros docs\Roadmap Estratégico_ Ciclo de Vida do OTServer (Vaelor).md` — 10 fases
- `Outros docs\Relatório Exaustivo de Desenvolvimento e Solução de Erros_ Projeto Vaelor.md` — erros vencidos
- `Outros docs\Guia de Execução_ Fase 1 - Fundação e DevOps.docx` — guia de setup

## Aviso legal

Os assets do Tibia (`Tibia.dat`, `Tibia.spr`, `assets/`, `catalog.json`) são propriedade da **CipSoft GmbH**. Eles NÃO são versionados neste projeto e não devem ser distribuídos. Use apenas para fins pessoais/educativos com cliente do Tibia oficial instalado.
