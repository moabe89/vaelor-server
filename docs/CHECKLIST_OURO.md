# Checklist de Ouro — Antes de cada login

> Adaptado da seção 7 do `Outros docs\Relatório Exaustivo de Desenvolvimento e Solução de Erros_ Projeto Vaelor.md`. Sempre validar ANTES de tentar conectar.

## ✅ Pré-flight checklist

### Servidor (Canary)

- [ ] **`canary.exe` rodando?**
  ```powershell
  Get-Process canary -ErrorAction SilentlyContinue
  ```
  Se não estiver: `cd C:\ot\canary && .\canary.exe` (a janela preta exibe `Canary Server Online` quando OK)

- [ ] **MySQL/MariaDB rodando?**
  ```powershell
  Get-Service "MySQL*", "MariaDB" -ErrorAction SilentlyContinue
  ```
  Se XAMPP: abrir `xampp-control.exe` e startar MySQL.

- [ ] **Portas 7171 (login) e 7172 (game) liberadas?**
  ```powershell
  Test-NetConnection -ComputerName 127.0.0.1 -Port 7172
  ```

- [ ] **`config.lua` aponta para `127.0.0.1` em IP local?**
  ```powershell
  Select-String -Path "C:\ot\canary\config.lua" -Pattern "^ip\s*="
  ```

### Cliente (OTClient Mehah)

- [ ] **Cliente sendo aberto da pasta certa?**
  Sempre abrir `C:\ot\cliente_1524\otclient_dx_x64.exe` (não copiar para outro lugar).

- [ ] **Pasta `data/things/<versão>/` populada?**
  ```powershell
  $v = "1511"  # ou versão correspondente
  Get-ChildItem "C:\ot\cliente_1524\data\things\$v\" | Select Name, Length
  ```
  Esperado: `Tibia.dat`, `Tibia.spr`, `catalog.json`, `assets/` (Directory)

- [ ] **Nomes dos arquivos sem `.txt` ou `.dat.dat` extras?**
  ```powershell
  Get-ChildItem "C:\ot\cliente_1524\data\things\$v\" -File | Where Name -notmatch "^(Tibia\.(dat|spr)|catalog\.json)$" | Select Name
  ```
  Saída esperada: vazia.

- [ ] **Versão no `setup.otml` ≥ versão escolhida no dropdown?**
  ```powershell
  Select-String -Path "C:\ot\cliente_1524\data\setup.otml" -Pattern "last-supported-version"
  ```

### Login

- [ ] **Caixa "Ativar login HTTP" marcada** (necessário para versões 15.x)
- [ ] **IP do servidor no cliente = `127.0.0.1`** (loopback, mesmo PC)
- [ ] **Conta de teste = Account `1`, Password `1`** (padrão do schema canary.sql)

## 🔍 Pós-flight (validar que rodou)

- [ ] **Servidor logou conexão recebida?**
  ```powershell
  Get-Content "C:\ot\canary\canary.log" -Tail 20
  ```
  Esperado: linha tipo `Player <Nome> has logged in.`

- [ ] **Cliente sem erros novos no log?**
  ```powershell
  Get-Content "C:\ot\cliente_1524\otclient.log" -Tail 30
  ```
  Não deve ter `ERROR:` após o último `== application started`.

## 🚨 Arquivos CRÍTICOS — backup obrigatório antes de mexer

Hook automático em `.claude/scripts/backup_before_edit.py` cria backup `.bak.<timestamp>`. Mas se editar manualmente fora do agente, fazer cópia:

| Arquivo | Por quê é crítico |
|---|---|
| `canary/config.lua` | Portas, IP, rates — quebra servidor inteiro se errado |
| `canary/schema.sql` | Schema do banco — corromper = perder personagens |
| `canary/CMakeLists.txt` | Build system — erro = não compila mais |
| `canary/CMakePresets.json` | Presets de build |
| `canary/data/items/items.xml` | Items do jogo — XML inválido = servidor não inicia |
| `canary/data/monster/*.xml` | Monstros |
| `canary/data/npc/*.xml` | NPCs |
| `canary/data/XML/vocations.xml` | Vocations (Knight, Druid, etc.) |
| `canary/data/XML/groups.xml` | Grupos de permissão (player, GM, GOD) |
| `cliente_1524/data/setup.otml` | Configuração do cliente — versão suportada, viewport |
| `cliente_1524/modules/client_things/things.lua` | Carregador de DAT/SPR |
| `cliente_1524/modules/client_entergame/entergame.lua` | Tela de login |
| `cliente_1524/CMakeLists.txt` | Build system do cliente |
| `cliente_1524/vcpkg.json` | Manifesto de deps do cliente |

## 🚧 Armadilhas conhecidas (do relatório)

1. **Extensões ocultas Windows.** `Tibia.dat` pode na verdade ser `Tibia.dat.txt`. Sempre `Get-ChildItem` para validar.
2. **Hierarquia profunda.** `data/things/0/1500/Tibia.dat` é ERRADO. Correto: `data/things/1500/Tibia.dat`.
3. **`catalog-content.json` não vira `catalog.json` automaticamente.** Renomear na mão.
4. **`appearances.dat` é o nome real.** Renomear cópia para `Tibia.dat`.
5. **`.spr` não existe em 15.x.** Cópia binária do `.dat` engana o validador.
