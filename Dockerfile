# From https://github.com/go-skynet/LocalAI/blob/master/Dockerfile
FROM localai/localai:v2.24.2-vulkan-ffmpeg-core

# TODO: update dockerfile

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
