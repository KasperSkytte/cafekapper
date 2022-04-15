# Update the NODE_VERSION arg in docker-compose.yml to pick a Node version: 10, 12, 14
ARG NODE_VERSION=14
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-${NODE_VERSION}

# VARIANT can be either 'hugo' for the standard version or 'hugo_extended' for the extended version.
ARG VARIANT=hugo
# VERSION can be either 'latest' or a specific version number
ARG VERSION=0.96.0

# Download Hugo
RUN apt-get update && apt-get install -y ca-certificates openssl git curl && \
    rm -rf /var/lib/apt/lists/* && \
    case ${VERSION} in \
    latest) \
    export VERSION=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4)}') ;;\
    esac && \
    echo ${VERSION} && \
    case $(uname -m) in \
    aarch64) \
    export ARCH=ARM64 ;; \
    *) \
    export ARCH=64bit ;; \
    esac && \
    echo ${ARCH} && \
    wget -O ${VERSION}.tar.gz https://github.com/gohugoio/hugo/releases/download/v${VERSION}/${VARIANT}_${VERSION}_Linux-${ARCH}.tar.gz && \
    tar xf ${VERSION}.tar.gz && \
    rm ${VERSION}.tar.gz && \
    mv hugo /usr/bin/hugo

# Copy the site and work from there
RUN mkdir -p /src/cafekapper.dk/
COPY cafekapper.dk/ /src/cafekapper.dk/
WORKDIR /src/cafekapper.dk/

# build and serve site, including content marked as draft
# bind to 0.0.0.0 instead of default 127.0.0.1 
ENTRYPOINT [ \
    "hugo", \
    "server", \
    "-d", \
    "/www/cafekapper.dk", \
    "-D", \
    "--bind", \
    "0.0.0.0" \
]
