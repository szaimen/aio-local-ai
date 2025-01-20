# From https://github.com/go-skynet/LocalAI/blob/master/Dockerfile
FROM quay.io/go-skynet/local-ai:v2.25.0-aio-cpu

COPY --chmod=775 start.sh /start.sh

# hadolint ignore=DL3008
RUN set -ex; \
    \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        netcat-openbsd \
    ; \
    rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3002
USER root
ENTRYPOINT [ "/start.sh" ]
