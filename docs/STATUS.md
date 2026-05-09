# Vaelor — STATUS atual

**Snapshot:** 2026-05-08 (Fechamento da Sessão PC - Preparação para migração Mac)

## Resumo do Progresso
Hoje resolvemos os maiores gargalos do projeto. O cliente está totalmente funcional com as novas vocações (Monk) e o ambiente Sandbox (recursos infinitos e altas taxas) foi ativado. O projeto está pronto para a etapa de deploy online.

## Componentes

| Componente | Estado | Localização | Notas |
|---|---|---|---|
| **Engine Canary (v3.4.0)** | ✅ Funcional | `C:\ot\canary\` | Rodando liso. Banco de Dados atualizado e sem erros de `players_online`. |
| **OTClient (v4.0)** | ✅ Funcional | `C:\ot\cliente_4.0\` | Cliente legado descartado. Versão atual (Redemption) compilada. Console preto escondido (`WINDOWS_GUI`). |
| **Minimapa** | ✅ Importado | `%APPDATA%\otcr\otclient` | Importador Lua criado. Os 1069 blocos de mapa foram carregados no cache (`minimap.otmm`). |
| **Banco de Dados (MySQL)** | ✅ Online | XAMPP | Tabelas corrigidas. Personagens `GOKU` e `Vegeta` (Monk) criados. |
| **AAC web (MyAAC)** | ✅ Configurado (Local) | `C:\xampp\htdocs\` | Configurado para suportar 5 vocações (incluindo Exalted Monk). |
| **VPS online / Mac Setup** | ⏳ Próxima Fase | — | Pendente migração para o ambiente do Mac e posterior deploy na nuvem. |

## Modificações Sandbox (Fase 4) - ✅ ATIVO
- **Itens Infinitos:** Runas, Potions e Munições não gastam cargas (`config.lua`).
- **XP Progressiva:** 200x (lvl 1-100) até 25x (lvl 1001+) configurado em `stages.lua`.
- **Skills Globais:** 50x para Skills, 30x para Magic Level (`config.lua` + `stages.lua`).
- **Regeneração (HP/Mana):** Multiplicada por 30 para **todas** as vocações direto no `vocations.xml`.

## Bloqueio ATIVO 🔴
**Nenhum!** Todos os erros anteriores de cliente, protocolo 1500 (janela preta) e banco de dados foram solucionados nesta sessão.

## Próximas ações sugeridas (Para a sessão no Mac)

1. **Sincronização dos Arquivos:** Transferir a pasta `C:\ot` (ou fazer commit/push no Git) do PC Windows para o Mac. Fazer backup do banco de dados MySQL via phpMyAdmin.
2. **Ambiente Mac:** Instalar dependências necessárias no Mac se quiser rodar o servidor localmente lá (Homebrew, MySQL/XAMPP para Mac).
3. **Fase 7 e 8 (VPS / Online):**
   - Configurar o servidor em uma VPS Ubuntu (Linux) para ficar online 24/7.
   - Ajustar o IP global no `config.lua` e no `init.lua` do cliente.
   - Finalizar detalhes de segurança do MyAAC (Recaptcha, etc).

## Roadmap atualizado
- ✅ Fases 1 a 3 — Fundação, Engine e Banco de Dados.
- ✅ Fase 4 — Customização Sandbox.
- ✅ Fase 5 — Configuração de Mapa (Completo).
- ✅ Fase 6 — Configuração do Cliente 4.0 (Mehah).
- 🔄 Fases 7 e 8 — AAC Web Finalização e VPS (Próximos passos).

## Comandos Úteis do Cliente (GOD)
- `/town Thais` - Teleporta para Thais
- `/teleport X, Y, Z` - Teleporta para coordenadas exatas
- `/c Nome` - Puxa um jogador até você
