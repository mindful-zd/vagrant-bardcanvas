#!/usr/bin/env bash


debconf-set-selections <<< 'mysql-server mysql-server/root_password password qq$!@pu07087'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password qq$!@pu07087'

apt-get update
apt-get install -y apache2 libapache2-mod-php5 php5-gd php5-mysql mysql-server libphp-pclzip php-net-ftp php5-curl emacs24-nox php5-memcache php5-mcrypt php5-imap php5-tidy unzip

locale-gen es_LA.utf8

cp /vagrant/etc/site.conf /etc/apache2/sites-available/
rm /etc/apache2/sites-enabled/*
ln -s ../sites-available/site.conf /etc/apache2/sites-enabled/site.conf

mkdir /etc/apache2/ssl
cp /vagrant/etc/server.key /etc/apache2/ssl/
cp /vagrant/etc/server.crt /etc/apache2/ssl/

sed -i 's/short_open_tag \= Off/short_open_tag \= On/g' /etc/php5/apache2/php.ini

a2enmod rewrite
a2enmod ssl
php5enmod mcrypt
php5enmod imap
php5enmod tidy

service apache2 restart

if [ ! -d /var/lib/mysql/site ];
then
    mysql -u root -p'qq$!@pu07087' -e "create database site default charset=utf8"
    mysql -u root -p'qq$!@pu07087' -e "grant all privileges on site.* to 'webapp'@'localhost' identified by 'qerqwepqwerpuiupo'"
    mysql -u root -p'qq$!@pu07087' -e "flush privileges"
    mysql -u root -p'qq$!@pu07087' site < /vagrant/etc/site.sql
else
    echo 'DB ALREADY CREATED';
fi

#usermod -G vagrant www-data
#mkdir /public_html
#cd /public_html
#wget https://bardcanvas.com/download/installer.zip
#unzip installer.zip
#rm installer.zip

cp -r /vagrant/public_html /

chown -R www-data:www-data /public_html
