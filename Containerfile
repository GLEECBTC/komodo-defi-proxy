# Compilation
FROM docker.io/library/debian:bookworm-slim AS build
WORKDIR /usr/src/komodo-defi-proxy

## Install Rust
RUN apt-get update \
	&& apt-get install -y --no-install-recommends build-essential ca-certificates curl pkg-config libssl-dev \
	&& rm -rf /var/lib/apt/lists/*
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

COPY . .

RUN cargo build --release

# Runtime
FROM docker.io/library/debian:bookworm-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates libssl3 \
	&& rm -rf /var/lib/apt/lists/*
RUN update-ca-certificates

## Get binary
COPY --from=build /usr/src/komodo-defi-proxy/target/release/komodo-defi-proxy /usr/local/bin/

## Init command
CMD ["komodo-defi-proxy"]
