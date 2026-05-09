# Dockerfile para deploy do Canary no Easypanel (VPS)
# Build multi-stage: compila o Canary do zero sem NuGet

# ---- Stage 1: Compilacao ----
FROM ubuntu:24.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake git build-essential ca-certificates curl zip unzip tar \
    pkg-config ninja-build autoconf automake libtool \
    python3 tzdata \
    && ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

# Instalar vcpkg usando o commit definido no vcpkg.json do projeto
WORKDIR /opt
COPY canary/vcpkg.json /opt/vcpkg.json
RUN vcpkgCommitId=$(grep '.builtin-baseline' vcpkg.json | awk -F: '{print $2}' | tr -d '," \r\n') \
    && echo "vcpkg commit ID: $vcpkgCommitId" \
    && git clone https://github.com/microsoft/vcpkg.git \
    && cd vcpkg \
    && git checkout "$vcpkgCommitId" \
    && ./bootstrap-vcpkg.sh

# Instalar dependencias do projeto via vcpkg (sem NuGet cache)
WORKDIR /opt/vcpkg_manifest
COPY canary/vcpkg.json /opt/vcpkg_manifest/
RUN /opt/vcpkg/vcpkg install \
    --x-manifest-root=/opt/vcpkg_manifest \
    --x-install-root=/opt/vcpkg_installed \
    --triplet=x64-linux \
    --host-triplet=x64-linux

# Compilar o Canary
WORKDIR /srv
COPY canary/ /srv/

RUN export VCPKG_ROOT=/opt/vcpkg/ && \
    cmake --preset linux-release \
      -DTOGGLE_BIN_FOLDER=ON \
      -DVCPKG_MANIFEST_INSTALL=OFF \
      -DVCPKG_INSTALLED_DIR=/opt/vcpkg_installed && \
    cmake --build --preset linux-release

# ---- Stage 2: Imagem final leve ----
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-client curl ca-certificates tzdata \
    && ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /canary

# Copiar binario compilado
COPY --from=builder /srv/build/linux-release/bin/canary /bin/canary

# Copiar arquivos de dados do servidor
COPY canary/data /canary/data
COPY canary/data-canary /canary/data-canary
COPY canary/data-otservbr-global /canary/data-otservbr-global
COPY canary/config.lua /canary/config.lua
COPY canary/schema.sql /canary/schema.sql
COPY canary/key.pem /canary/key.pem

EXPOSE 7171 7172

CMD ["/bin/canary"]
