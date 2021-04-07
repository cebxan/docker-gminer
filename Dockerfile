FROM ubuntu:20.04 AS builder

WORKDIR /tmp

RUN mkdir gminer \
    && apt update \
    && apt install tar wget xz-utils ca-certificates -y --no-install-recommends  \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/develsoftware/GMinerRelease/releases/download/2.50/gminer_2_50_linux64.tar.xz && \
    tar xf gminer_2_50_linux64.tar.xz -C gminer


FROM nvidia/cuda:11.2.2-base

LABEL maintainer="Dockminer"

LABEL org.opencontainers.image.source https://github.com/dockminer/gminer

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