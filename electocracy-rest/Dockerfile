FROM rust:1.69.0-buster as builder

COPY . /workdir
WORKDIR /workdir
RUN cargo install --path . --root /opt/electocracy


FROM debian:buster-slim
COPY --from=builder /opt/electocracy /opt/electocracy
ENTRYPOINT ["/opt/electocracy"]
