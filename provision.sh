#!/bin/bash


sudo apt-get update
echo 'mysql-server-5.7 mysql-server/root_password password 1' | sudo debconf-set-selections
echo 'mysql-server-5.7 mysql-server/root_password_again password 1' | sudo debconf-set-selections
sudo apt-get install -y python-software-properties apache2 gcc cpp libxml2-dev make g++ apache2-dev libxslt1-dev zlib1g-dev libcurl-ocaml-dev mc libpng-dev libgmp-dev libmysqlclient-dev mysql-server mysql-client autoconf 
sudo sed 's/bind-address/#bind-address/g' /etc/mysql/mysql.conf.d/mysqld.cnf > /etc/mysql/mysql.conf.d/mysqld2.cnf 
sudo rm /etc/mysql/mysql.conf.d/mysqld.cnf 
sudo cp /etc/mysql/mysql.conf.d/mysqld2.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart

wget http://in1.php.net/distributions/php-5.3.29.tar.bz2
sudo ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h
tar -xvf php-5.3.29.tar.bz2
cd php-5.3.29
sudo ./configure --sysconfdir=/etc --with-apxs2 --with-mysql --with-gd --with-zlib --enable-sockets --enable-soap --enable-gd-native-ttf --with-gmp=/usr/include/x86_64-linux-gnu --with-iconv --with-pcre-regex --with-curl --with-zlib --enable-exif --enable-ftp --enable-magic-quotes --enable-sysvsem --enable-sysvshm --enable-sysvmsg --with-kerberos --enable-ucd-snmp-hack --enable-shmop --enable-calendar --without-sqlite --with-libxml-dir=/usr --without-gd --disable-dom --disable-dba --without-unixODBC --disable-pdo --disable-xmlreader --disable-xmlwriter --disable-phar --disable-fileinfo --disable-json --without-pspell --disable-wddx --disable-posix --disable-sysvmsg --disable-sysvshm --disable-sysvsem
sudo make
sudo make install
sudo chmod 777 /etc/apache2/mods-enabled/php5.load
sudo echo "AddType application/x-httpd-php .php" >> /etc/apache2/mods-enabled/php5.load
sudo chmod 644 /etc/apache2/mods-enabled/php5.load
sudo cp /home/vagrant/php-5.3.29/php.ini-production /usr/local/lib/php.ini
sudo chmod 777 /usr/local/lib/php.ini
sudo echo "extension=xdebug.so" >> /usr/local/lib/php.ini
sudo chmod 644 /usr/local/lib/php.ini
sudo a2dismod mpm_event
sudo a2enmod mpm_prefork

sudo touch /var/www/html/index.php
sudo chmod 777 /var/www/html/index.php
sudo echo '<?php phpinfo(); ?>' >> /var/www/html/index.php
cd ~
wget https://xdebug.org/files/xdebug-2.1.4.tgz
tar -xvf xdebug-2.1.4.tgz
cd ./xdebug-2.1.4
phpize 
./configure --enable-xdebug
make
sudo make install


sudo service apache2 restart


