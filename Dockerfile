FROM rust as builder
WORKDIR /usr/src/aceitchecripto
COPY . .
RUN cargo install --path .

FROM debian:buster-slim
COPY --from=builder /usr/local/cargo/bin/aceitche-cripto /usr/local/bin/aceitche-cripto
COPY src/frontend/* /var/src/
COPY img/* /var/img/
CMD ["aceitche-cripto"]