# From https://github.com/authcrunch/authcrunch/blob/main/Dockerfile
FROM ghcr.io/authcrunch/authcrunch:v1.0.14 as caddy

# From https://github.com/go-skynet/LocalAI/blob/master/Dockerfile
FROM quay.io/go-skynet/local-ai:v3.1.1-aio-gpu-vulkan

# Copy the Caddy binary from the first stage
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=caddy /config/caddy /config/caddy
COPY --from=caddy /data/caddy /data/caddy
COPY --from=caddy /etc/caddy /etc/caddy
COPY --from=caddy /usr/share/caddy /usr/share/caddy


# Needed for Nextcloud AIO so that image cleanup can work.
# Unfortunately, this needs to be set in the Dockerfile in order to work.
LABEL org.label-schema.vendor="Nextcloud"