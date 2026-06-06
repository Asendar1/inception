FROM alpine:3.22

RUN apk update && apk add --no-cache ca-certificates wget tar

RUN wget -O /tmp/mailpit.tar.gz \
    https://github.com/axllent/mailpit/releases/download/v1.30.1/mailpit-linux-amd64.tar.gz \
    && tar -xzf /tmp/mailpit.tar.gz -C /usr/local/bin/ \
    && chmod +x /usr/local/bin/mailpit \
    && rm /tmp/mailpit.tar.gz

EXPOSE 1025 8025

CMD ["mailpit"]
