# Primeiro Contato — Prompts para abrir o agente Vaelor

> Quando você abrir Claude Code OU Antigravity dentro de `C:\ot\` pela primeira vez, copie e cole um dos prompts abaixo.

## Prompt RECOMENDADO (curto + direto)

```
Olá. Sou Moabe (advogado, OAB/GO 42.979).

Você é o agente dev-otserv-vaelor. Roda em ambos os clients (Claude Code e Antigravity/Gemini).

Por favor faça seu smoke check inicial:
1. Leia seu próprio CLAUDE.md (se Claude) ou GEMINI.md (se Antigravity)
2. Leia docs/STATUS.md (estado atual)
3. Leia docs/DIAGNOSTICO_INICIAL.md (problema atual do cliente OT que está bloqueando)
4. Confirme que os 4 MCPs configurados (.mcp.json: github, context7, filesystem, memory) estão acessíveis
5. Apresente o resumo do estado em linguagem leiga (sou advogado, não programador)
6. Sugira o próximo passo prático

NÃO mexa em nenhum arquivo do C:\ot\canary\ ou C:\ot\cliente_1524\ ainda.
Só leia, analise e me reporte.
```

## Prompt ALTERNATIVO (foco direto no problema atual)

```
Olá, sou Moabe.

Meu OT não abre — o cliente Mehah está dando "1524 recognized as installed
client, but not supported" e cascata de erros Lua em entergame.lua.

Por favor invoque a skill diagnose-otclient-startup (ou rode /diagnose-startup
se disponível) e me apresente:
- causa raiz em linguagem leiga
- as opções de fix ordenadas por risco (do menor para o maior)
- sua recomendação

NÃO aplique nenhum fix sem minha autorização. Só diagnostique e proponha.

Eu sou advogado, não dev — fala em linguagem de leigo.
```

## O que esperar como resposta

O agente deve:
1. Confirmar que leu CLAUDE.md/GEMINI.md, STATUS.md, DIAGNOSTICO_INICIAL.md
2. Dar um resumo do estado:
   - ✅ Canary compilado (`canary.exe`)
   - ✅ OTClient extraído
   - ✅ Assets 15.24 importados
   - ❌ Cliente não abre (erro de versão)
3. Apresentar **3-4 opções de fix** ordenadas por risco
4. Esperar a sua decisão sobre qual aplicar

## Regras de comunicação que ele já sabe

Do CLAUDE.md/GEMINI.md raiz:
- **Linguagem leiga SEMPRE** — analogias antes de termos técnicos
- **Resumir antes de explicar**
- **Tradução de jargão obrigatória** na primeira aparição (DAT, vcpkg, CMake, etc.)
- **Em mudanças 🔴 ALTO**, explicar O QUE + POR QUE + RISCOS antes de fazer
- **Termômetro 🟢🟡🟠🔴 sempre visível**

Se ele falar técnico demais, basta dizer:
> "fala em linguagem leiga, sou advogado"

E ele ajusta na hora.

## Pendências que ele vai mencionar (PRIORIDADES)

1. **🔴 PRIORIDADE 1** — Destravar o OT localmente (problema atual do cliente)
2. **🟡 PRIORIDADE 2** — Customização Sandbox (Fase 4: rates, itens infinitos)
3. **🟡 PRIORIDADE 3** — AAC web + Deploy VPS Online (Fases 7-8)
4. **🟢 PRIORIDADE 4** — Mapa custom Vaelor via RME (Fase 5)

## Slash commands disponíveis

- `/diagnose-startup` — diagnóstico do OTClient não abrindo (USE SEMPRE QUE DER ERRO)

(Mais slash commands serão adicionados conforme o projeto avança: `/build-canary`, `/sandbox-mode`, `/deploy-online`, etc.)

---

**Versão:** 1.0 — 2026-05-08
**Criado por:** agent-architect-v1 ao montar o agente Vaelor
