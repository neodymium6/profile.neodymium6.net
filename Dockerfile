# syntax=docker/dockerfile:1

ARG HUGO_VERSION=0.155.2
ARG BASE_URL=https://profile.neodymium6.net/

FROM debian:bookworm-slim AS hugo
ARG HUGO_VERSION
ARG TARGETARCH
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget tar \
 && rm -rf /var/lib/apt/lists/* \
 && case "${TARGETARCH}" in \
      amd64) HUGO_ARCH="Linux-64bit" ;; \
      arm64) HUGO_ARCH="Linux-ARM64" ;; \
      arm) HUGO_ARCH="Linux-ARM" ;; \
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
RUN hugo --minify --environment production --baseURL "${BASE_URL}"

FROM nginx:1.27-alpine AS runtime
COPY --from=build /site/public /usr/share/nginx/html
