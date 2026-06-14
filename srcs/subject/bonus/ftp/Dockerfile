FROM alpine:3.22

RUN apk update && apk add --no-cache vsftpd

RUN mkdir -p /var/run/vsftpd/empty && chmod 555 /var/run/vsftpd/empty

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 21

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
