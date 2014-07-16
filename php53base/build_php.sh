#!/bin/bash
workdir=/tmp/php-build
prefix=/usr/share/php-5.3
bin=/usr/share/php-5.3/bin
cd "$workdir"
./configure --prefix="$prefix" --with-apxs2
make clean
make
make install
cp /tmp/php.ini /usr/share/php-5.3/lib/php.ini
cd "$workdir/ext/"
extensions=(curl mbstring mcrypt gd mysql openssl pdo_mysql pgsql pdo_pgsql zip zlib)
for i in "${extensions[@]}"
do
  cd "$workdir/ext/$i"
  if [[ "$i" == "openssl" ]] ; then
    mv ./config0.m4 ./config.m4
  fi
  eval "$bin/phpize"
  make clean
  ./configure --with-php-config="$bin/php-config"
  make
  make install
  echo "extension=$i.so" >> /usr/share/php-5.3/lib/php.ini 
done


