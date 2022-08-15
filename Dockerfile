ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base:6.1.0

FROM "n8nio/n8n:0.190.0" as n8n

FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY --from=n8n /n8n /opt/n8n
COPY --from=n8n /web-vault /opt/web-vault

RUN \
    apt-get update \
    \
    && apt-get install -y --no-install-recommends \
        libmariadb-dev-compat=1:10.5.15-0+deb11u1 \
        libpq5=13.7-0+deb11u1 \
        nginx=1.18.0-6.1+deb11u2 \
        sqlite3=3.34.1-3 \
    && apt-get clean \
    && rm -f -r \
        /etc/nginx \
    \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/error.log

COPY rootfs /

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Viacheslav Kharchenko <vchkhr@vchkhr.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Viacheslav Kharchenko <vchkhr@vchkhr.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
