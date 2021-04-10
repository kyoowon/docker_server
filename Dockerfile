#1. debian:buster
# FROM는 베이스가 될 이미지를 설정. debian의 최신 안정화 버전을 buster로 지칭.
FROM    debian:buster
# MAINTAINER는 이미지를 생성한 사람의 정보를 설정. MAINTAINER 생성자가 지양하도록 변경되어 LABEL을 통해 maintainer를 지정.
LABEL   MAINTAINER="kyulee@student.42Seoul.kr"

#2. 페키지 설치
# 리눅스에서 쓰이는 패키지 관리 명령어 도구. 다양한 페키지를 설치하기위해 업데이트를 진행.
RUN		apt-get update

RUN     apt-get -y install \
	    nginx \
	    openssl \
	    php7.3-fpm

RUN		apt-get -y install \
		mariadb-server \
		php-mysql \
		php-mbstring

# wget를 이용한 파일 다운시 필요(phpmyadmin & wordpress) 빠른 실행을 위해 소스를 미리 다운.
# RUN	    apt-get -y install wget \
# 			vim

#3. src 디렉토리에서 필요한 파일들을 복사.
COPY    ./srcs/* /tmp/srcs/

#4. run
# 호스트와 바인딩할 포트를 지정.
EXPOSE  80 443

# 컨테이너 실행시 주로 작업디렉토리를 지정.
WORKDIR /tmp/srcs/

# WORKDIR에서 지정한 디렉토리에 있는 init.sh를 실행.
CMD     bash init.sh



# dockerfile로 빌드 (파일이 위치한 곳에서 다음 명령어 실행)
# - docker build -t ft_server .
# docker run
# - docker run -p 80:80 -p 443:443 ft_server

# docker 컨테이너 삭제
# - docker rm test
# docker에 실행 중인 컨테이너 중지, 컨테이너와 이미지 모두 삭제
# - docker stop $(docker ps -aq)
# - docker system prune -a
# process 찾기 (포트번호를 넣으면 해당 포트에 PID를 알 수 있음)
# lsof -i :포트번호
# 포트를 점유하고 있는 process kill
# kill -9 [PID]