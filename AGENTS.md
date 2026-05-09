# dev-otserv-vaelor — Índice universal de agentes

> Este é o índice **universal** que clients agnósticos podem ler. Os arquivos canônicos com instruções completas são `CLAUDE.md` (Claude Code) e `GEMINI.md` (Antigravity). Conteúdo idêntico nos dois.

## Projeto

**Vaelor** — OTServer Tibia 15.x rodando Canary + OTClient Mehah DX11. Modo sandbox/solo.

## Ferramentas suportadas

| Cliente | Arquivo de instruções | Pasta de configuração |
|---|---|---|
| Claude Code (Anthropic) | `CLAUDE.md` | `.claude/` |
| Antigravity (Google Gemini) | `GEMINI.md` | `.gemini/` |

## Sub-agentes

- `canary-cpp-builder` — compilação C++ + debug
- `otclient-mehah-modder` — cliente Mehah + assets
- `lua-game-scripter` — scripts gameplay

## Skills críticas

- `diagnose-otclient-startup`
- `import-tibia-global-assets`
- `compile-canary-windows`
- `compile-otclient-mehah`

## Para começar

Ver `docs/PRIMEIRO_CONTATO.md` para o prompt inicial.

## Estado atual

Ver `docs/STATUS.md`.
