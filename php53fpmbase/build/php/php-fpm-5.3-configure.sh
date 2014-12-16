#/bin/sh

./configure \
	--disable-all \
	--prefix="/opt/php-5.3" \
	--enable-bcmath=shared \
	--enable-fpm \
	--enable-hash \
	--enable-json \
	--enable-libxml \
	--enable-mbstring=shared \
	--enable-session=shared \
	--enable-xml=shared \
	--enable-zip=shared \
	--with-curl=shared \
	--with-gd=shared \
	--with-jpeg-dir=/usr \
	--with-mysql=shared \
	--with-mysqli=shared \
	--with-pear \
	--with-pdo=shared \
	--with-pdo_pgsql=shared \
	--with-png-dir=/usr \	
	--with-sqlite3=shared \
        --with-zlib=shared \
	
