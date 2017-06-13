FROM goodrainapps/alpine:3.6

ENV VERSION 4.7.1
ENV URL https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-all-languages.tar.gz

RUN set -x \
    && apk add --no-cache php5 php5-fpm php5-pdo php5-pdo_mysql php5-json php5-opcache nginx \
    && mkdir /run/nginx/ -pv
    && curl --output phpMyAdmin.tar.gz --location $URL && \
    && tar xzf phpMyAdmin.tar.gz && \
    && rm -f phpMyAdmin.tar.gz phpMyAdmin.tar.gz.asc && \
    && mv phpMyAdmin* /www && \
    && rm -rf /www/js/jquery/src/ /www/examples /www/po/

COPY etc etc
COPY config.inc.php /www/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+rwx /docker-entrypoint.sh


EXPOSE 80

ENV PHP_UPLOAD_MAX_FILESIZE=64M \
    PHP_MAX_INPUT_VARS=2000

ENTRYPOINT [ "/docker-entrypoint.sh" ]
