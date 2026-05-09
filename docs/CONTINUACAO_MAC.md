# Continuacao no Mac — Sessao 2026-05-09

## Cenario

Voce (proximo agente) vai continuar o deploy do servidor Vaelor na VPS Hostinger.
A sessao anterior foi feita no PC Windows do Moabe e parou com myAAC dando HTTP 500.
Moabe migrou para o Mac e copiou a pasta do projeto via Dropbox.

## PRIMEIRA AÇÃO — ler arquivos CHAVE

```
docs/STATUS.md         <- estado completo do deploy
walkthrough.md         <- passo-a-passo geral
.env                   <- senhas (LOCAL no Mac, NAO commitado)
docker-compose.yml     <- arquitetura Docker
Dockerfile.aac         <- build do myAAC
aac/docker-entrypoint.sh <- script que gera config.lua
```

## ULTIMO BLOQUEIO

myAAC retorna `HTTP/1.0 500 Internal Server Error` com `Content-Length: 0` no curl direto.

Apos importar tabelas myaac_* via root user (resolveu erro de TRIGGER permission),
o curl AINDA retorna 500 vazio. Precisa investigar logs do PHP/Apache.

### Comando para diagnosticar (rodar no SSH `root@31.97.151.29`)

```bash
docker compose logs --tail=80 aac 2>&1 | grep -iE "error|fatal|warning" | tail -20
```

E tambem testar em outras URLs:

```bash
# Testar pagina principal
curl -i http://127.0.0.1:8081/ 2>&1 | head -20

# Testar acesso interno do container ao banco
docker compose exec aac php -r 'try { new PDO("mysql:host=database;dbname=canary", "canary", "yQHznOx7QODicXnxEpY8JUD17oJeNrGG"); echo "DB OK\n"; } catch (Exception $e) { echo "ERRO: " . $e->getMessage(); }'
```

## Hipoteses do erro 500 atual

1. **Cache PHP/twig** ainda com erro antigo — solucao: `docker compose exec aac rm -rf /var/www/html/system/cache/*`
2. **Permissoes** — solucao: `docker compose exec aac chown -R www-data:www-data /var/www/html`
3. **myAAC nao consegue conectar no DB** — testar PDO direto no container
4. **Configuracao incompleta** — myAAC pode estar esperando alguma tabela/setting que nao foi importada

## Como acessar a VPS do Mac

### SSH
A chave SSH gerada no Windows (`~/.ssh/id_ed25519`) **NAO copia automaticamente para o Mac**. Voce vai precisar:

1. **Opção A:** Gerar nova chave no Mac e adicionar no painel Hostinger:
   ```bash
   ssh-keygen -t ed25519 -C "moabe.a.sousa@gmail.com"
   cat ~/.ssh/id_ed25519.pub  # copiar para o painel Hostinger
   ```

2. **Opção B:** Copiar a chave do Windows pro Mac via Dropbox (~/.ssh/id_ed25519 e ~/.ssh/id_ed25519.pub)
   - No Mac: copiar para ~/.ssh/, dar permissao 600
   - `chmod 600 ~/.ssh/id_ed25519`
   - `chmod 644 ~/.ssh/id_ed25519.pub`

### Conectar
```bash
ssh root@31.97.151.29
```

## Estrutura do Projeto

```
ot/
├── canary/              <- servidor Canary (C++ source + config)
├── cliente_4.0/         <- OTClient Mehah Redemption (Windows binarios — nao usavel no Mac sem recompilacao)
├── aac/                 <- myAAC PHP/Apache (do XAMPP local Windows)
├── vcpkg/               <- dependencias C++ (so Windows, gitignored)
├── docs/                <- documentacao
│   ├── STATUS.md
│   ├── DIAGNOSTICO_INICIAL.md
│   └── CONTINUACAO_MAC.md (este arquivo)
├── docker-compose.yml   <- 3 servicos: database, aac, server
├── Dockerfile           <- build canary Linux
├── Dockerfile.aac       <- build myAAC PHP-Apache
├── walkthrough.md       <- passo-a-passo Easypanel
├── vaelor_db.sql        <- dump UTF-16 (gitignored)
├── vaelor_db_utf8.sql   <- dump UTF-8 (gitignored, ja importado na VPS)
└── .env                 <- senhas (gitignored, criar copia no Mac)
```

## TESTAR LOGIN NO CLIENTE

Como o cliente OTClient é Windows binary, no Mac voce nao pode testar diretamente.
Opcoes:
1. Usar Wine
2. Manter o teste no PC Windows (deixar Moabe rodar do Windows quando voltar)
3. Compilar OTClient para Mac (mais trabalhoso)

Por enquanto, foco e deixar o myAAC respondendo corretamente via curl.
Quando o curl retornar JSON com personagens, Moabe pode testar o cliente Windows depois.

---
*Documentado por Claude Code Sonnet 4.6 em 2026-05-09 — para continuar no Mac.*
