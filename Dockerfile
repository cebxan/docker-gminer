FROM ubuntu:20.04 AS builder

WORKDIR /tmp

ARG GMINER_VERSION="2.54"
ARG GMINER_FILENAME="gminer_2_54_linux64.tar.xz"

RUN mkdir gminer \
    && apt update \
    && apt install -y --no-install-recommends tar wget xz-utils ca-certificates  \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/develsoftware/GMinerRelease/releases/download/${GMINER_VERSION}/${GMINER_FILENAME} && \
    tar xf gminer_2_51_linux64.tar.xz -C gminer


FROM nvidia/cuda:11.2.2-base

LABEL maintainer="Carlos Berroteran (cebxan)"

LABEL org.opencontainers.image.source https://github.com/cebxan/docker-gminer

# Fix Driver bug
RUN ln -s /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libnvidia-ml.so

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt update \
    && apt install tzdata -y --no-install-recommends  \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/gminer/miner /usr/local/bin/miner

EXPOSE 8080

ENV TZ America/Caracas

ENTRYPOINT [ "miner" ]