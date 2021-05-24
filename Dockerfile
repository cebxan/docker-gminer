FROM ubuntu:20.04 AS builder

WORKDIR /tmp

ARG GMINER_VERSION="2.54"
ARG GMINER_FILENAME="gminer_2_54_linux64.tar.xz"

RUN mkdir gminer \
    && apt update \
    && apt install -y --no-install-recommends tar wget xz-utils ca-certificates  \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/develsoftware/GMinerRelease/releases/download/${GMINER_VERSION}/${GMINER_FILENAME} && \
    tar xf ${GMINER_FILENAME} -C gminer

FROM ghcr.io/cebxan/gpu-computing

LABEL maintainer="Carlos Berroteran (cebxan)"
LABEL org.opencontainers.image.source https://github.com/cebxan/docker-gminer

COPY --from=builder /tmp/gminer/miner /usr/local/bin/miner

EXPOSE 8080

ENV TZ America/Caracas

ENTRYPOINT [ "miner" ]