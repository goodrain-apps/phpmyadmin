FROM goodrainapps/alpine:3.6

RUN apk add --no-cache php5-cli php5-mysqli php5-ctype php5-xml \
    php5-gd php5-zlib php5-bz2 php5-zip php5-openssl php5-curl \
    php5-opcache php5-json


ENV VERSION 4.7.1
ENV URL https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-all-languages.tar.gz

RUN set -x  && \
    curl --output phpMyAdmin.tar.gz --location $URL && \
    tar xzf phpMyAdmin.tar.gz && \
    rm -f phpMyAdmin.tar.gz phpMyAdmin.tar.gz.asc && \
    mv phpMyAdmin* /www && \
    rm -rf /www/js/jquery/src/ /www/examples /www/po/

COPY config.inc.php /www/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+rwx /docker-entrypoint.sh


EXPOSE 80

ENV PHP_UPLOAD_MAX_FILESIZE=64M \
    PHP_MAX_INPUT_VARS=2000

ENTRYPOINT [ "/docker-entrypoint.sh" ]
