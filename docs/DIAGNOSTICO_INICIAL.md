# Diagnóstico Inicial — OTClient não conecta

**Data:** 2026-05-08
**Lido por:** agent-architect-v1 ao criar o agente Vaelor
**Fonte:** `cliente_1524\otclient.log` (linhas 1-200, múltiplos timestamps de 18:36 a 18:42)

## Sintoma observado

Toda execução do `otclient_dx_x64.exe` resulta em:

```
== application started at May 07 2026 18:42:35
== operating system: Windows
OTClient - Redemption 4.x rev 0.000 (desenv) built on Jan 13 2026 for arch x64

Warning: 1524 recognized as an installed client, but not supported.

ERROR: Lua exception: /client_entergame/entergame.lua:116:
       attempt to compare number with nil
ERROR: Unable to load module 'client_entergame'
ERROR: Unable to load module 'client_serverlist': dependency
       'client_entergame' has failed to load

Startup done :]
```

Quando o usuário clica "Entrar":
```
ERROR: Lua exception: /client_entergame/entergame.lua:745:
       attempt to compare number with nil
ERROR: protected lua call failed
```

## Análise técnica

### O que está funcionando
- ✅ `otclient_dx_x64.exe` carrega
- ✅ Module loader inicia
- ✅ DirectX 11 inicializa
- ✅ Renderer abre janela (não há erro de SDL/DX)

### O que está quebrando

1. **Cliente reconhece Tibia 1524 instalado no PC** (`%LocalAppData%\Tibia\packages\Tibia\package.json` provavelmente reporta 15.24).
2. **Mas Mehah Redemption 4.x deste binário (build 13/01/2026) não suporta 1524.**
3. Confirmação em `data/setup.otml`:
   ```
   last-supported-version: 1511
   ```
4. Quando o cliente tenta carregar info da versão 1524, recebe `nil`.
5. Em `entergame.lua:116` (função `updateLabelText`):
   ```lua
   if version > someThreshold then ...  -- version é nil → erro
   ```
6. Cascata: `client_entergame` falha → `client_serverlist` (que depende dele) falha.

### Estado dos assets

`Get-ChildItem "C:\ot\cliente_1524\data\things\1500\"`:
```
Tibia.dat       4850390 bytes  (4.85 MB) — appearances.dat renomeado
Tibia.spr       4850390 bytes  (mesmo tamanho — cópia binária do dat)
catalog.json    1008440 bytes  (1.00 MB) — catalog-content.json renomeado
assets/         (Directory com sprites)
```

Os 5 erros do `Relatório Exaustivo` foram superados nesta importação:
- ✅ Nome `Tibia.dat` (não appearances.dat)
- ✅ `Tibia.spr` presente (cópia binária)
- ✅ Hierarquia `data/things/1500/` (não /0/1500/)
- ✅ Sem extensão oculta `.txt`
- ✅ `catalog.json` presente (não catalog-content.json)

**Os assets estão corretos. O problema é o MISMATCH DE VERSÃO entre o que está nos assets (1524) e o que o cliente Mehah suporta (até 1511).**

## Opções de fix

Detalhe completo em `.claude/skills/diagnose-otclient-startup/SKILL.md` Fix D.

### Opção A — Usar versão 1511 (RECOMENDADO PRIMEIRO)
- 🟡 **Risco médio**
- Renomear `data/things/1500/` → `data/things/1511/`
- Selecionar `1511` no dropdown do login
- **Trade-off:** sprites/itens introduzidos no Tibia 15.12-15.24 vão faltar visualmente (provavelmente alguns NPCs, criaturas, paredes novas).
- **Vantagem:** zero recompilação, fix em segundos.

### Opção B — Atualizar binário OTClient Mehah
- 🟠 **Risco médio-alto**
- Verificar https://github.com/mehah/otclient/releases para release que suporte 1524
- Baixar e substituir `otclient_dx_x64.exe`
- **Trade-off:** pode quebrar customizações locais em `modules/`.

### Opção C — Recompilar OTClient do source
- 🔴 **Risco alto**
- Compilar HEAD da master via skill `compile-otclient-mehah`
- 15-30 min de build, pode ter falhas no caminho.
- **Justificativa:** se A e B não bastarem.

### Opção D — Downgrade dos assets
- 🟢 **Risco baixo**
- Se Tibia 15.11 estiver disponível (versão antiga em archive de community), reextrair assets dessa versão
- **Limitação:** Tibia 15.24 já está instalado, downgrade do client oficial é trabalhoso.

## Recomendação para Moabe

**Tentar Opção A primeiro** — é o fix de menor risco e mais rápido. Se algumas criaturas/itens aparecerem como "?" ou faltarem visualmente, partir para Opção B.

## Como aplicar Opção A (passo a passo, em linguagem leiga)

> "Vamos enganar o cliente para que ele acredite que os assets que temos são da versão 15.11, não 15.24. Como o cliente OTClient só sabe lidar com até a 15.11, isso destrava a tela de login."

```powershell
# 1. Renomear a pasta da versão
Rename-Item "C:\ot\cliente_1524\data\things\1500" "1511"

# 2. Abrir o cliente e selecionar versão 1511 no dropdown de login
```

Se o cliente abrir e mostrar a tela de login normal → vitória parcial.
Se o cliente conectar no servidor → vitória total.
