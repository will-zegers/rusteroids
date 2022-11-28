FROM rust:1.65.0 AS BUILDER

WORKDIR /usr/src/rusteroids

# Create a layer that pre-builds dependency crates
COPY Cargo.* ./
RUN apt update              \
  && apt install -y         \
    librust-alsa-sys-dev    \
    librust-libudev-sys-dev \
  && mkdir -p src/          \
  && touch src/lib.rs       \
  && cargo build --release  \
  && rm src/lib.rs

# Now, build from source
COPY . .
RUN cargo install --path .

FROM debian:buster-slim
COPY --from=BUILDER /usr/local/cargo/bin/rusteroids /usr/local/bin/rusteroids
CMD ["rusteroids"]
