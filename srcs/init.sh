#!/bin/sh

# 주로 이용할 공간에 유저 그룹 권한설정을 통해 접근.
chown -R www-data:www-data /var/www/
chmod -R 755 ../../var/www/

# ssl 설정 - https에 대한 설정.
openssl req -x509 -newkey rsa:4096 -days 365 -nodes \
        -subj "/C=KR/ST=Seoul/L=Seoul/O=Ansan/OU=developer/CN=localhost" \
        -keyout localhost.dev.key -out localhost.dev.crt
mv localhost.dev.key ../../etc/ssl/private/
mv localhost.dev.crt ../../etc/ssl/certs/

# ssl에 대한 접근 권한 제한.
chmod 600 ../../etc/ssl/certs/localhost.dev.crt ../../etc/ssl/private/localhost.dev.key

# nginx 설정.
if [ $NOTAUTOINDEX -eq 1 ]; then
        cp -rp NotAuto_default ../../etc/nginx/sites-available/default
else
        cp -rp default ../../etc/nginx/sites-available/default
fi

# Wordpress 설치
# wget https://wordpress.org/latest.tar.gz
tar -xvf wordpress-5.7.tar.gz
mv wordpress/ ../../var/www/html/

# 권한설정. - wordpress
chmod -R 755 ../../var/www/wordpress/
chown -R www-data:www-data /var/www/html/wordpress

# wp-config.php 파일 추가.
cp -rp my-wp-config.php ../../var/www/html/wordpress/wp-config.php

# phpmyadmin 설치.
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin ../../var/www/html/

# phpmyadmin - config.inc.php 파일을 추가.
cp -rp my-config.inc.php ../../var/www/html/phpmyadmin/config.inc.php 

# mysql wordpress & phpmyadmin 테이블 및 권한 생성.
# phpmyadmin - mysql로 리다이렉션 시킴.
service mysql start
mysql < ../../var/www/html/phpmyadmin/sql/create_tables.sql
mysql < create_wordpress.sql

# 권한설정. - phpmyadmin
chmod -R 755 ../../var/www/html/phpmyadmin/
chown -R www-data:www-data ../../var/www/html/phpmyadmin

# mysql 갱신.
service mysql reload
# nginx 실행.
service nginx start
#php7.3-fpm 실행.
service php7.3-fpm start

# while 통해 컨테이너가 종료되지 않고 포그라운드 방식으로 계속 남아 있을 수 있도록 함.
# 프로세스가 실행되는 동안 명령 프롬프트상에서 아무것도 할 수 없음.
while :
do
        sleep 100
done

# 만약 컨테이너를 터미널로 접근이 필요한 경우 bash를 활용
# bash

# dockerfile로 빌드 (파일이 위치한 곳에서 다음 명령어 실행)
# - docker build -t ft_server .
# docker run
# - docker run [--name test] [-p 80:80 -p 443:443] [-e NOTAUTOINDEX = 1] ft_server

# docker 컨테이너 삭제
# - docker rm test
# docker에 실행 중인 컨테이너 중지, 컨테이너와 이미지 모두 삭제
# - docker stop $(docker ps -aq)
# - docker system prune -a

# process 찾기 (포트번호를 넣으면 해당 포트에 PID를 알 수 있음)
# - lsof -i :80
# 포트를 점유하고 있는 process kill
# - kill -9 [PID]