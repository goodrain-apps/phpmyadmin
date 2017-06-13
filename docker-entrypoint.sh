#!/bin/bash

[ $DEBUG ]  && set -x

if [ ! -f /app/phpmyadmin/config.secret.inc.php ] ; then
    cat > /app/phpmyadmin/config.secret.inc.php <<EOT
<?php
\$cfg['blowfish_secret'] = '`cat /dev/urandom | tr -dc 'a-zA-Z0-9~!@#$%^&*_()+}{?></";.,[]=-' | fold -w 32 | head -n 1`';
EOT
fi

echo -e "Start php-fpm in background."
php-fpm5


TIMEOUT=${TIMEOUT:-30}
while [ $TIMEOUT -gt 0 ]
do
    nc -w 1  ${MYSQL_HOST:-127.0.0.1} ${MYSQL_PORT:-3306} 2>&1 >/dev/null
    if [ $? -eq 0 ];then
        echo "MySQL service connect ok."
        break
    fi
    echo "Waiting MySQL service $TIMEOUT seconds"
    TIMEOUT=`expr $TIMEOUT - 1`;
    sleep 1
done

if [ $TIMEOUT -eq 0 ]; then
	echo >&2 'Start failed,please ensure mysql service has started.'
	exit 1
else
  echo -e "Start nginx in foreground...\n"
  nginx -g 'daemon off;'
fi
