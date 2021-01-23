## Helper Image
FROM alpine:3.13 AS builder
RUN apk add --no-cache curl jq py-pygments

# Install the latest release of Caddy
ARG CADDY_TAG
RUN caddy_tag=${CADDY_TAG:-$(curl -s https://api.github.com/repos/mholt/caddy/releases/latest | jq -r '.tag_name')} && \
    curl -o caddy.tar.gz -fsSL "https://github.com/mholt/caddy/releases/download/${caddy_tag}/caddy_${caddy_tag}_linux_amd64.tar.gz" && \
    tar -C /usr/local/bin/ -xz -f caddy.tar.gz caddy && \
    rm caddy.tar.gz

# Install the latest release of Hugo
ARG HUGO_TAG
RUN hugo_tag=${HUGO_TAG:-$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r '.tag_name')} && \
    hugo_version=$(echo $hugo_tag | cut -c2-) && \
    curl -o hugo.tar.gz -fsSL "https://github.com/gohugoio/hugo/releases/download/${hugo_tag}/hugo_${hugo_version}_Linux-64bit.tar.gz" && \
    tar -C /usr/local/bin/ -xz -f hugo.tar.gz hugo && \
    rm hugo.tar.gz

# Build site
WORKDIR /site
COPY . .
RUN hugo --gc --minify --baseURL "http://localhost:8080"


## Final Image
FROM alpine:3.13
RUN apk add --no-cache ca-certificates

LABEL maintainer="Milad" \
      homepage="https://milad.dev" \
      repository="https://github.com/moorara/milad.dev"

# https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.version="$VERSION" \
      org.opencontainers.image.revision="$REVISION" \
      org.opencontainers.image.created="$BUILD_TIME" \
      org.opencontainers.image.source="https://github.com/moorara/milad.dev"

WORKDIR /www
COPY Caddyfile .
COPY --from=builder /site/public/ public/
COPY --from=builder /usr/local/bin/caddy /usr/local/bin/caddy

# EXPOSE 80 443
# ENTRYPOINT [ "caddy" ]

USER nobody
EXPOSE 8080 8443
ENTRYPOINT [ "caddy", "-http-port", "8080", "-https-port", "8443" ]
