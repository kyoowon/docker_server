#!/bin/sh

chown -R www-data:www-data /var/www/
chmod -R 755 ../../var/www/

# ssl 설정 - https에 대한 설정
openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Lee/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
mv localhost.dev.key ../../etc/ssl/private/
mv localhost.dev.crt ../../etc/ssl/certs/
chmod 600 ../../etc/ssl/certs/localhost.dev.crt ../../etc/ssl/private/localhost.dev.key

# nginx 설정
cp -rp default ../../etc/nginx/sites-available/

# Wordpress 설치 및 설정
# wget https://wordpress.org/latest.tar.gz
# tar -xvf latest.tar.gz
# mv wordpress/ ../../var/www/html/
tar -xvf wordpress-5.7.tar.gz
mv wordpress/ ../../var/www/html/

# 유저 그룹 권한설정
chown -R www-data:www-data ../../var/www/html/wordpress

# wp-config.php 파일 수정
cp -rp my-wp-config.php ../../var/www/html/wordpress/wp-config.php

# mysql wordpress 테이블 및 권한 생성
service mysql start
mysql -u root --skip-password < create_wordpress.sql

# phpmyadmin 설치
# wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin ../../var/www/html/

cp -rp config.my.inc.php ../../var/www/html/phpmyadmin/config.inc.php 

# 권한설정
chown -R www-data:www-data ../../var/www/html/phpmyadmin/

# 현재 위치를 root에 위치 & 설치한 파일과 폴더을 삭제
cd ../../
rm -rfp ./tmp/srcs

# mysql 갱신
service mysql reload
# nginx 실행
service nginx start
#php7.3-fpm 실행
service php7.3-fpm start

# bash를 통해 컨테이너가 종료되지 않고 계속 남아 있을 수 있도록 함
bash