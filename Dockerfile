FROM alpine:latest
RUN apk add --no-cache \
  openssh-client \
  ca-certificates \
  bash \
  curl jq \
  tar \
  gzip \
  ruby