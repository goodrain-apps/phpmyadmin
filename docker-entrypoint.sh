#!/bin/bash

[ $DEBUG ]  && set -x

SECRET_CFG="/app/phpmyadmin/config.secret.inc.php"
PAM_CFG="/app/phpmyadmin/config.inc.php"
PHP_CFG="/etc/php5/php.ini"
NGINX_CFG="/etc/nginx/nginx.conf"
DELIMITER="="
# php.ini config
export CFG_UPLOAD_MAX_FILESIZE=${CFG_UPLOAD_MAX_FILESIZE:-128M}
export CFG_POST_MAX_SIZE=${CFG_POST_MAX_SIZE:-128M}


function set_config() {
    CONFIG_FILE=$1
    CFG=($( env | sed -nr "s/CFG_([0-9A-Z_a-z-]*)/\1/p"|tr A-Z a-z))

    for CFG_KEY in "${CFG[@]}"; do
        KEY=`echo $CFG_KEY | cut -d = -f 1`
        VAR=`echo $CFG_KEY | cut -d = -f 2`
        if [ "$VAR" == "" ]; then
            echo "Empty volue for option \"$KEY\"."
            continue
        fi
        grep -q "$KEY" $CONFIG_FILE
        if (($? > 0)); then
            echo "${KEY}${DELIMITER}${VAR}" >> $CONFIG_FILE
            echo "Config add option for \"$KEY\"."
        else
            sed -i -r "s~#?($KEY)[ ]*${DELIMITER}.*~\1 ${DELIMITER} $VAR~g" $CONFIG_FILE  >/dev/null 2>&1
            echo "Option found for \"$KEY\"."
        fi
    done
}

echo "Check and set php config..."
set_config $PHP_CFG

echo "Generate secret key..."
if [ ! -f ${SECRET_CFG} ] ; then
    cat > ${SECRET_CFG} <<EOT
<?php
\$cfg['blowfish_secret'] = '`cat /dev/urandom | tr -dc 'a-zA-Z0-9~!@#$%^&*_()+}{?></";.,[]=-' | fold -w 32 | head -n 1`';
EOT
fi

# replace config with env
MYSQL_HOST=${MYSQL_HOST:-127.0.0.1}
MYSQL_PORT=${MYSQL_PORT:-3306}
sed -i -r "s/_MYSQL_HOST_/\'$MYSQL_HOST\'/" $PAM_CFG
sed -i -r "s/_MYSQL_PORT_/\'$MYSQL_PORT\'/" $PAM_CFG



echo -e "Start php-fpm in background."
php-fpm5


sleep ${PAUSE:-0}

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
