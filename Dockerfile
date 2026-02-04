# Build stage
FROM debian:bookworm-slim AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src

ENV HUGO_VERSION=0.155.1
RUN curl -L \
  https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
  | tar -xz \
  && mv hugo /usr/local/bin/hugo

COPY . .
RUN hugo --minify

# Runtime stage
FROM nginx:alpine
COPY --from=build /src/public /usr/share/nginx/html

