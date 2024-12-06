## Helper Image
FROM alpine:3.21 AS builder
RUN apk add --no-cache curl git jq py-pygments

# Install the latest release of Caddy
RUN caddy_tag=$(curl -s https://api.github.com/repos/caddyserver/caddy/releases/latest | jq -r '.tag_name') && \
    caddy_version=$(echo $caddy_tag | cut -c2-) && \
    curl -o caddy.tar.gz -fsSL "https://github.com/caddyserver/caddy/releases/download/${caddy_tag}/caddy_${caddy_version}_linux_amd64.tar.gz" && \
    tar -C /usr/local/bin/ -xz -f caddy.tar.gz caddy && \
    rm caddy.tar.gz

# Install the latest release of Hugo
RUN hugo_tag=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r '.tag_name') && \
    hugo_version=$(echo $hugo_tag | cut -c2-) && \
    curl -o hugo.tar.gz -fsSL "https://github.com/gohugoio/hugo/releases/download/${hugo_tag}/hugo_${hugo_version}_Linux-64bit.tar.gz" && \
    tar -C /usr/local/bin/ -xz -f hugo.tar.gz hugo && \
    rm hugo.tar.gz

# Build site
WORKDIR /site
COPY . .
RUN hugo --gc --minify --baseURL "http://localhost:8080"


## Final Image
FROM alpine:3.21

# https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.source="https://github.com/moorara/milad.dev"

RUN apk add --no-cache ca-certificates nss-tools

WORKDIR /www
COPY Caddyfile .
COPY --from=builder /site/public/ public/
COPY --from=builder /usr/local/bin/caddy /usr/local/bin/caddy

HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost:8080/health || exit 1

EXPOSE 8080 8443
ENTRYPOINT [ "caddy", "run" ]
