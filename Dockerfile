FROM alpine:latest

RUN apk add --no-cache php5-cli php5-mysqli php5-ctype php5-xml \
    php5-gd php5-zlib php5-bz2 php5-zip php5-openssl php5-curl \
    php5-opcache php5-json

RUN apk add --no-cache tzdata libc6-compat && \
       ln -s /lib /lib64 && \
       cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
       echo "Asia/Shanghai" >  /etc/timezone && \
       date && apk del --no-cache tzdata
       
RUN apk add --no-cache wget curl bash su-exec && \
    sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

COPY phpmyadmin.keyring /

ENV VERSION 4.6.6
ENV URL https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-all-languages.tar.gz

RUN set -x \
    && export GNUPGHOME="$(mktemp -d)" \
    && apk add --no-cache curl wget gnupg \
    && curl --output phpMyAdmin.tar.gz --location $URL \
    && curl --output phpMyAdmin.tar.gz.asc --location $URL.asc \
    && gpgv --keyring /phpmyadmin.keyring phpMyAdmin.tar.gz.asc phpMyAdmin.tar.gz \
    && apk del --no-cache gnupg \
    && rm -rf "$GNUPGHOME" \
    && tar xzf phpMyAdmin.tar.gz \
    && rm -f phpMyAdmin.tar.gz phpMyAdmin.tar.gz.asc \
    && mv phpMyAdmin* /www \
    && rm -rf /www/js/jquery/src/ /www/examples /www/po/

COPY config.inc.php /www/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+rwx /docker-entrypoint.sh


EXPOSE 80

ENV PHP_UPLOAD_MAX_FILESIZE=64M \
    PHP_MAX_INPUT_VARS=2000

ENTRYPOINT [ "/docker-entrypoint.sh" ]
