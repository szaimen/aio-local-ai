# From https://github.com/go-skynet/LocalAI/blob/master/Dockerfile
FROM quay.io/go-skynet/local-ai:v1.30.0-ffmpeg

COPY --chmod=775 start.sh /start.sh

# hadolint ignore=DL3002
USER root
ENTRYPOINT [ "/start.sh" ]
CMD ["/usr/bin/local-ai"]
