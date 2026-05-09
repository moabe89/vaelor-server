#!/bin/bash
set -e

# Gera /canary/config.lua dinamicamente usando env vars do compose
# (resolve o problema de "Undefined constant os" quando myAAC parseia config.lua original)

mkdir -p /canary
cat > /canary/config.lua << EOF
-- Config gerado automaticamente para o myAAC ler
-- Valores reais vem das env vars do docker-compose
dataPackDirectory = "data-otservbr-global"
coreDirectory = "data"

-- MySQL (valores reais)
mysqlHost = "${MYSQL_HOST:-database}"
mysqlUser = "${MYSQL_USER:-canary}"
mysqlPass = "${MYSQL_PASSWORD}"
mysqlDatabase = "${MYSQL_DATABASE:-canary}"
mysqlPort = 3306
mysqlSock = ""
passwordType = "sha1"

-- Argon2 (compativel com canary)
memoryConst = "1<<16"
temporaryConst = 2
parallelism = 2

-- Auth
authType = "password"

-- Server
ip = "0.0.0.0"
loginProtocolPort = 7171
gameProtocolPort = 7172
statusProtocolPort = 7171
serverName = "${SERVER_NAME:-Vaelor}"
url = "${SERVER_URL:-http://31.97.151.29:8081/}"
location = "BRA"
ownerName = "Moabe"
ownerEmail = ""

-- Status
statusTimeout = 5000
maxPlayers = 0

-- World
worldType = "pvp"
mapName = "otservbr"
mapAuthor = "OpenTibiaBR"
EOF

echo "[entrypoint] config.lua gerado com sucesso para myAAC"

# Inicia Apache em foreground (modo Docker)
exec apache2-foreground
