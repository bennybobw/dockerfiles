#!/bin/bash
workdir=/tmp/php-build
prefix=/opt/php-5.3.28/
bin=/usr/share/php-5.3/bin
cd "$workdir"
./configure --prefix="$prefix" --with-apxs2
make clean
make
make install
cp /opt/php-5.3.28/


