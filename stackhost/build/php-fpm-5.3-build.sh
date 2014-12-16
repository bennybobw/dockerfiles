#!/bin/bash

PHP_VER=php-5.3.29
PHP_VER_SHORT=php-5.3

mkdir -p "/tmp/$PHP_VER"
cd "/tmp/$PHP_VER"
wget "http://us2.php.net/get/$PHP_VER.tar.bz2/from/this/mirror" -O "/tmp/$PHP_VER_SHORT.tar.bz2" && tar -xjf "/tmp/$PHP_VER_SHORT.tar.bz2" --strip-components=1
BASE_DIR="/opt/$PHP_VER_SHORT"
mkdir -p "$BASE_DIR"
PREFIX_DIR="$BASE_DIR/build"
CONFIG_DIR="$BASE_DIR/conf"
XDEBUG_DIR="$BASE_DIR/xdebug"

#get opt flags
#while getopts :p:c:h FLAG; do
#  case $FLAG in
#    p)  #set option "b"
#      PREFIX_DIR=$OPTARG
#      echo "-p used: $OPTARG"
#      echo "PREFIX_DIR = $PREFIX_DIR"
#      ;;
#    c)  #set option "c"
#      CONFIG_DIR=$OPTARG
#      echo "-c used: $OPTARG"
#      echo "CONFIG_DIR = $CONFIG_DIR"
#      ;;
#    h)  #show help
#      HELP
#      ;;
#    \?) #unrecognized option - show help
#      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
#      HELP
#  esac
#done

mkdir -p "$PREFIX_DIR"
mkdir -p "$CONFIG_DIR"
mkdir "$BASE_DIR/xdebug"
mkdir "$BASE_DIR/zend_extensions"

#if we need shared module plus dir --enable-module=shared,/usr/mydir
#zlib is not shared currently because there is an error with ubuntu and php 5.5 if it's shared
./configure --prefix="$PREFIX_DIR"  \
  --with-config-file-path="$CONFIG_DIR" \
  --enable-bcmath=shared \
  --enable-calendar=shared \
  --enable-dba=shared \
  --enable-exif=shared \
  --enable-fpm \
  --enable-ftp=shared \
  --enable-hash \
  --enable-json \
  --enable-libxml \
  --enable-mbstring=shared \
  --enable-pcntl=shared \
  --enable-pdo \
  --enable-session \
  --enable-shmop=shared \
  --enable-soap=shared \
  --enable-sockets=shared \
  --enable-sysvmsg \
  --enable-sysvsem \
  --enable-sysvshm \
  --enable-xml=shared \
  --enable-wddx=shared \
  --enable-zip=shared \
  --with-bz2=shared \
  --with-curl=shared \
  --with-gd=shared \
  --with-gettext=shared \
  --with-jpeg-dir=/usr \
  --with-mcrypt=shared,/usr \
  --with-mhash=shared \
  --with-mysql=shared \
  --with-mysqli=shared \
  --with-openssl=shared \
  --with-pear \
  --with-pdo_mysql=shared  \
  --with-pdo_pgsql=shared \
  --with-png-dir=/usr \
  --with-readline=shared \
  --with-zlib

make -j4 && make install
cp -R "/tmp/$PHP_VER" "/opt/$PHP_VER/src"

#add xdebug
wget https://github.com/xdebug/xdebug/archive/XDEBUG_2_2_5.tar.gz -O /tmp/xdebug.tar.gz 
tar -xzf /tmp/xdebug.tar.gz --strip-components=1 -C "$XDEBUG_DIR"
cd "$XDEBUG_DIR"
#run phpize
"$PREFIX_DIR/bin/phpize"
./configure --enable-xdebug --with-php-config="$PREFIX_DIR/bin/php-config"
make
cp modules/xdebug.la "$BASE_DIR/zend_extensions"
cp modules/xdebug.so "$BASE_DIR/zend_extensions"




