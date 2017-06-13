# phpMyAdmin  for [ACP](https://www.goodrain.com/ACP.html)



> phpMyAdmin is a free software tool written in [PHP](https://php.net/), intended to handle the administration of [MySQL](https://www.mysql.com/) over the Web. phpMyAdmin supports a wide range of operations on MySQL and MariaDB. Frequently used operations (managing databases, tables, columns, relations, indexes, users, permissions, etc) can be performed via the user interface, while you still have the ability to directly execute any SQL statement.

![phpMyAdmin](http://ojfzu47n9.bkt.clouddn.com/20170613149735134020538.jpg)



# Supported tags and Dockerfile links

`4.7.1` , `4.7` `latest` [Dockerfile](https://github.com/goodrain-apps/phpmyadmin/blob/master/Dockerfile)

# About this image

This images base alpine system ,can be installed in Goodrain [ACM](http://app.goodrain.com/group/detail/11/). Fully compatible with the Goodrain [ACP](https://www.goodrain.com/ACP.html) platform.

# How to use this image

## Via ACM install

[![deploy to ACP](http://ojfzu47n9.bkt.clouddn.com/20170603149649013919973.png)](http://app.goodrain.com/group/detail/11/)



## Via docker

### Installation

Automated builds of the image are available on [hub.docker.com](https://quay.io/repository/sameersbn/postgresql) and is the recommended method of installation.

```bash
docker pull goodrainapps/phpmyadmin
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/goodrain-apps/phpmyadmin.git
cd phpmyadmin
make 
```

### Quick Start

Start mysql service,then use `--link `  with phpmyadmin.

```bash
# 1.run mysql service
docker run -d --name mysql \
-e MYSQL_ROOT_PASSWORD=pass4word mysql

# 2.run phpmyadmin
docker run -d --name phpmyadmin \
--link mysql:db \
-e MYSQL_HOST=db \
-e MYSQL_PORT=3306 \
goodrainapps/phpmyadmin
```



# Environment variables

| Name       | Default   | Comments                                 |
| ---------- | --------- | ---------------------------------------- |
| MYSQL_HOST | 127.0.0.1 | MySQL service ip address                 |
| MYSQL_PORT | 3306      | MySQL service port                       |
| CFG_*      | null      | The variable name beginning with CFG_ is used to replace the php.ini file configuration |
| TIMEOUT    | 30        | MySQL service check timeout              |
| DEBUG      | null      | docker-entrypoint.sh debug switch        |
| PAUSE      | null      | docker-entrypoint.sh pause for debug     |



# Modify PHP config file at Launch

This image supports modifying the php.ini configuration item when the container is started.

The following settings are set up by default:

```bash
export CFG_UPLOAD_MAX_FILESIZE=${CFG_UPLOAD_MAX_FILESIZE:-128M}
export CFG_POST_MAX_SIZE=${CFG_POST_MAX_SIZE:-128M}
```

You can specify the configuration when starting the container, such as setting the `upload_max_filesize`,environment variable name must begin with `CFG_`

```bash
docker run -d --name phpmyadmin \
--link mysql:db \
-e MYSQL_HOST=db \
-e MYSQL_PORT=3306 \
-e CFG_POST_MAX_SIZE=256M \
-e CFG_UPLOAD_MAX_FILESIZE=256M \
-e DEBUG=1 \
goodrainapps/phpmyadmin
```

