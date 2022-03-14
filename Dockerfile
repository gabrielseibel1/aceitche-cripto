# Leveraging the pre-built Docker images with 
# cargo-chef and the Rust toolchain
FROM lukemathwalker/cargo-chef:latest-rust-1.59.0 AS chef
WORKDIR aceitche-cripto

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder 
COPY --from=planner /aceitche-cripto/recipe.json recipe.json
# Build dependencies - this is the caching Docker layer!
RUN cargo chef cook --release --recipe-path recipe.json
# Build application
COPY . .
RUN cargo build --release --bin aceitche-cripto

# We do not need the Rust toolchain to run the binary!
FROM debian:bullseye-slim AS runtime
WORKDIR aceitche-cripto
COPY --from=builder /aceitche-cripto/target/release/aceitche-cripto /usr/local/bin
COPY .env /aceitche-cripto/.env
COPY src/frontend/* /aceitche-cripto/src/frontend/
COPY img/* /aceitche-cripto/img/
ENTRYPOINT ["/usr/local/bin/aceitche-cripto"]
