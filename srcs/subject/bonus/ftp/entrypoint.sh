#!/bin/sh

set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

if ! id -u "${FTP_USER}" >/dev/null 2>&1; then
    adduser -D -h /var/www/wordpress "${FTP_USER}"
    echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
fi

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
