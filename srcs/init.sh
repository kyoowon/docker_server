#!/bin/sh

# 주로 이용할 공간에 유저 그룹 권한설정을 통해 접근.
chown -R www-data:www-data /var/www/
chmod -R 755 ../../var/www/

# ssl 설정 - https에 대한 설정.
openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Lee/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
mv localhost.dev.key ../../etc/ssl/private/
mv localhost.dev.crt ../../etc/ssl/certs/

# ssl 권한설정.
chmod 600 ../../etc/ssl/certs/localhost.dev.crt ../../etc/ssl/private/localhost.dev.key

# nginx 설정.
AUTO=`echo $`
if [ $NOTAUTOINDEX -eq 1 ]; then
        cp -rp NotAuto_default ../../etc/nginx/sites-available/default
else
        cp -rp default ../../etc/nginx/sites-available/default
fi

# Wordpress 설치
# wget https://wordpress.org/latest.tar.gz
tar -xvf wordpress-5.7.tar.gz
mv wordpress/ ../../var/www/html/

# 유저 그룹 권한설정. - wordpress
chown -R www-data:www-data ../../var/www/html/wordpress

# wp-config.php 파일 수정.
cp -rp my-wp-config.php ../../var/www/html/wordpress/wp-config.php

# mysql wordpress 테이블 및 권한 생성.
service mysql start
mysql -u root --skip-password < create_wordpress.sql

# phpmyadmin 설치.
# wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin ../../var/www/html/

# phpmyadmin - mysql 접근을 위한 설정.
cp -rp my-config.inc.php ../../var/www/html/phpmyadmin/config.inc.php 

# 유저 그룹 권한설정. - phpmyadmin
chown -R www-data:www-data ../../var/www/html/phpmyadmin/

# 현재 위치를 root에 위치 & 설치한 파일과 폴더을 삭제.
cd ../../
rm -rf ./tmp/srcs

# mysql 갱신.
service mysql reload
# nginx 실행.
service nginx start
#php7.3-fpm 실행.
service php7.3-fpm start

# while 통해 컨테이너가 종료되지 않고 포그라운드 방식으로 계속 남아 있을 수 있도록 함.
while :
do
        sleep 100
done