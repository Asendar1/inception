FROM alpine:3.22

RUN apk update && apk add --no-cache darkhttpd

RUN mkdir -p /var/www/static-site

COPY index.html /var/www/static-site/index.html

EXPOSE 8081

CMD ["darkhttpd", "/var/www/static-site", "--port", "8081", "--no-listing"]
