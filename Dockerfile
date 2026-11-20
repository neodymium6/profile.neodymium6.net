# syntax=docker/dockerfile:1

ARG HUGO_VERSION=0.170.1
ARG BASE_URL=https://profile.neodymium6.net/

FROM debian:bookworm-slim AS hugo
ARG HUGO_VERSION
ARG TARGETARCH
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget tar \
 && rm -rf /var/lib/apt/lists/* \
 && case "${TARGETARCH}" in \
      amd64) HUGO_ARCH="linux-amd64" ;; \
      arm64) HUGO_ARCH="linux-arm64" ;; \
      *) echo "Unsupported TARGETARCH=${TARGETARCH}" && exit 1 ;; \
    esac \
 && wget -O /tmp/hugo.tar.gz \
    https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz \
 && tar -xzf /tmp/hugo.tar.gz -C /usr/local/bin hugo \
 && rm -f /tmp/hugo.tar.gz

FROM hugo AS build
ARG BASE_URL
WORKDIR /site
COPY . .
RUN test -d themes/PaperMod \
 && test -n "$(find themes/PaperMod -mindepth 1 -print -quit)" \
 || (echo "ERROR: themes/PaperMod is missing or empty. Run: git submodule update --init --recursive" >&2 && exit 1)
RUN hugo --minify --environment production --baseURL "${BASE_URL}" --panicOnWarning

FROM nginx:1.30.7-alpine AS runtime
RUN apk upgrade --no-cache libcrypto3 libssl3 zlib
COPY --from=build /site/public /usr/share/nginx/html
