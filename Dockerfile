FROM alpine:latest
RUN apk add --no-cache \
  openssh-client \
  ca-certificates \
  bash \
  curl jq \
  tar \
  gzip

COPY load-secure-files /usr/bin/
RUN chmod +x /usr/bin/load-secure-files
