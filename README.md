# 0. 과제에 대한 이해

**ft_server**는 시스템 관리 개념을 소개하기 위한 과제이다. **스크립트를 사용**하여 업무를 자동화하는 것의 중요성을 깨닫게 될 것이다. 이를 위해 **Docker** 기술을 학습하고 완전한 **웹 서버를 설치**해 본다.

### 소개

- 이 서브젝트는 시스템 관리를 소개합니다.
- 이는 스크립트를 사용하여 작업을 자동화하는 것의 중요성을 알려줄 겁니다. 이를 위해, 당신은 “docker”기술을 이해하고 이를 이용해 완전한 웹 서버를 설치하십시오.
- 이 서버는 동시에 여러 서비스를 실행할 것입니다. : `Wordpress`, `phpMyAdmin`, `SQL database`.

### 일반 지침

- ./srcs/서버_구성에_필요한_모든_파일_넣기
- ./srcs/워드프레스_웹사이트에_필요한_모든_파일_넣기
- ./Dockerfile
    - 도커파일이 당신의 컨테이너를 빌드 할 것입니다. docker compose는 사용 금지.

### 필수 파트

- 딱 하나의 도커 컨테이너에 `Nginx`가 있는 웹 서버를 설정해야합니다. 컨테이너 OS는 꼭 `debian buster`여야합니다
- 웹 서버는 여러 서비스를 동시에 실행할 수 있어야합니다.
    - 그 서비스들은 `WordPress` 웹 사이트, `phpMyAdmin`, `MySQL` 입니다.
    - `SQL 데이터베이스`가 `WordPress` 및 `phpMyAdmin`과 작동하는지 확인해야합니다.
- 서버는 `SSL 프로토콜`을 사용할 수 있어야합니다.
- URL에 따라 서버가 올바른 웹 사이트로 리디렉션되는지 확인해야합니다.
- 서버가 오토 인덱스로 실행 중인지 확인하고, 이를 비활성화 할 수 있어야합니다.

# 1. Docker

Docker는 **리눅스 기반의 컨테이너**를 생성하여 **매우 가벼운 모듈식 가상 머신처럼 다룰 수 있습니다.** 또한 컨테이너를 구축, 배포, 복사하고 한 환경에서 다른 환경으로 이동하는 등 유연하게 사용할 수 있어, 애플리케이션을 클라우드에 최적화하도록 지원한다.

## 1). Docker를 쓰는 이유

하나의 서비스만을 제공하는 개발은 괜찮겠지만 만약 여러개의 서비스가 필요한 개발을 진행해야한다면

그리고 같은 개발 툴 기반으로 개발을 진행하고 다른 버전을 접근 한다고 하면 분명 충돌이 일어날 것이다.

이러한 충돌을 방지하고 각각의 서비스 환경을 조성할 수 있도록 담는 그릇을 만드는 것이 Docker이 할 일이다.

## 2). Docker와 VM가 어떤 차이

  위에 그림과 같이 VM은 집 안에 새로운 집을 짓는 것과 같다. 컴퓨터의 자원을 쪼개서 제한된 자원안에 서비스를 할 수 있도록 제한하는 것이며 또한 각각의 서비스에 OS가 깔리기 때문에 서비스에 필요한 OS의 기능 외에도 자원을 차지할 수 있게 된다.

  이와 대조적으로 Docker는 컨테이너라는 서비스마다의 공간을 할당해 서비스끼리 필요한 컴퓨터 자원은 공유하고 페키지 버전과 같은 것은 확실하게 분리함으로써 컴퓨터 자원을 보다 효율적으로 사용할 수 있도록 한다.

# 2. Docker install - Docker M1 mac Preview

현재 사용하고 있는 노트북이 실리콘 맥북 에어인 것을 감안해 Docker M1 mac Preview 버전을 다운 받아 진행하였다.

설치 링크

# 3. Docker 실행

### 1). 이미지 조회

```docker
docker image
```

### 2). 컨테이너 조회

```docker
docker ps -a
```

### 3). 컨테이너 중지

```docker
docker stop <컨테이너 이름 혹은 아이디>
```

### 4). 컨테이너 시작 (중지 된 컨테이너 시작) 및 재시작 (실행 중인 컨테이너 재부팅)

```docker
docker start <컨테이너 이름 혹은 아이디>
docker restart <컨테이너 이름 혹은 아이디>
```

### 5). 컨테이너 접속 (실행중인 컨테이너에 접속)

```docker
docker attach <컨테이너 이름 혹은 아이디>
```

### 6). Dockerfile로 빌드 (파일이 위치한 곳에서 다음 명령어 실행)

```docker
docker build -t <name> <location>
```

-t : target으로 설정한 이름으로 이미지 생성

<location> : 도커 파일의 위치 명시

### 7). docker run

```docker
docker run -it --name test -p 80:80 -p 443:443 ft_server
```

- i옵션은 interactive(입출력), t 옵션은 tty(터미널) 활성화
    - 일반적으로 터미널 사용하는 것처럼 컨테이너 환경을 만들어주는 옵션
- name [컨테이너 이름] 옵션을 통해 컨테이너 이름을 지정할 수 있다.
- p 호스트포트번호:컨테이너포트번호 옵션은 컨테이너의 포트를 개방한 뒤 호스트 포트와 연결한다.
    - 컨테이너 포트와 호스트 포트에 대한 개념이 궁금하다면 [여기](https://blog.naver.com/alice_k106/220278762795) 참고.

### 8). docker 컨테이너 삭제

```docker
docker rm test
```

### 9). docker에 실행 중인 컨테이너 중지, 컨테이너와 이미지 모두 삭제

```docker
docker stop $(docker ps -aq)
```

```docker
docker system prune -a
```

### 10). docker 환경변수 전달 (-e옵션)

```
docker run -e NOTAUTOINDEX=1 <이미지 이름 혹은 아이디>
```

Docker 컨테이너의 환경변수를 설정하기 위해서는 `-e` 옵션을 사용합니다. 또한, `-e` 옵션을 사용하면 Dockerfile의 `ENV` 설정도 덮어써지게 됩니다.

### 11). docker 컨테이너 명령어 접근

```bash
docker exec <컨테이너 이름 혹은 아이디> <하고자하는 명령어>
```

# 4. Docker 데비안 버스터 이미지 생성

### **debian이란**

  데비안은 주로 무료 및 오픈 소스 소프트웨어로 구성된 운영 체제이며 대부분은 GNU 일반 공중 사용 허가서하에 있으며 데비안 프로젝트로 알려진 개인 그룹에 의해 개발되었다. Debian은 개인용 컴퓨터 및 네트워크 서버용으로 가장 널리 사용되는 Linux 배포판 중 하나이며 다른 여러 Linux 배포판의 기반으로 사용한다.

**debian:buster 이란 debian**의 ****최신 안정 릴리스를 가리 킵니다.

### debian 이미지 가져오기

```docker
docker pull debian:buster
```

> 왜 나는 docker run 이 안되는 거지?

```docker
docker run -it -p 80:80 -p 443:443 debian:buster

docker: Error response from daemon: Ports are not available: listen tcp 0.0.0.0:80: bind: address already in use.
```

다음과 같이 포트를 잡고 있다는 얘기가 계속 나와서 곤란,,,,

80포트가 이미 사용 되고 있다는 에러 표시에 다양한 방법으로 시도를 해봤는데..

```bash
sudo apachectl stop
```

결론부터 말하면 아파치로 80 포트를 잡고 있어서 되지 않았다.

인턴 과정에서 웹 개발을 한다고 아파치를 설치하고 80포트를 잡아 둔 것이 문제,,,

그 해결은 위와 같이 아파치를 stop 해두고 계속 진행하면 된다.

# 5. Nginx 설치

엔진엑스(Nginx)는 Igor Sysoev라는 러시아 개발자가 `동시접속 처리에 특화된` 웹 서버 프로그램이다. `Apache`보다 동작이 단순하고, 전달자 역할만 하기 때문에 동시접속 처리에 특화되어 있다.

동시접속자(약 700명) 이상이라면 서버를 증설하거나 Nginx 환경을 권장한다고 한다. 지금은 아파치가 시장 점유율이 압도적이지만, 아마존웹서비스(AWS) 상에서는 시장 점유율 44%에 달할정도로 가볍고, 성능이 좋은 엔진이라고 한다.

### **HTTP 프록시와 웹 서버 기능**

- 정적 파일과 인덱스 파일 표현, 자동 인덱싱 기능.
- 캐싱을 통한 리버스 프록시
- 로드 밸런싱
- 고장 진단
- SSL 지원
- 캐싱을 통한 FastCGI 지원
- Name-, IP-기반 가상서버
- FLV 스트리밍
- MP4 스트리밍 모듈을 이용한 MP4 스트리밍
- 웹페이지 접근 인증
- gzip 압축
- 10000개의 동시 접속을 처리할 수 있는 능력
- URL 다시쓰기 (URL rewriting)
- 맞춤 로깅
- 서버 사이드 기능 포함
- WebDAV

### **메일 프록시 기능**

- SMTP, POP3, IMAP 프록시
- STARTTLS 지원
- SSL 지원

### Nginx 설치

```bash
apt-get -y install nginx
```

## SSL(Secure Socket Layer) : self-signed SSL

> HTTPS(Hypertext Transfer Protocol over Secure Socket Layer)는 SSL위에서 돌아가는 HTTP의 평문 전송 대신에 **암호화된 통신을 하는 프로토콜**이다.

- 이런 HTTPS를 통신을 서버에서 구현하기 위해서는 신뢰할 수 있는상위기업 발급한 인증서가 필요로 한데 이런 발급 기관을 **CA(Certificate authority)**라고 한다. CA의 인증서를 발급받는것은 당연 무료가 아니다.

- self-signed SSL 인증서는 **자체적으로 발급받은 인증서이며, 로그인 및 기타 개인 계정 인증 정보를 암호화**한다. 당연히 브라우저는 신뢰할 수 없다고 판단해 접속시 보안 경고가 발생한다.

- self-signed SSL 인증서를 만드는 방법은 몇 가지가 있는데, 무료 오픈소스인 openssl 을 이용해 쉽게 만들수 있다.

- HTTPS를 위해 필요한 **개인키(.key), 서면요청파일(.csr), 인증서파일(.crt)**을 openssl이 발급해준다.

### self-signed 인증서 생성

```bash
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=kyulee/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
```

- `newkey rsa:4096`
    - 새 인증서 요청 및 4096 비트 RSA 키를 생성합니다. 기본값은 2048 비트입니다.
- `x509`

    -X.509 인증서를 생성합니다.

- `days 3650`
    - 인증서를 인증 할 기간입니다.

        3650은 10 년입니다.

        양의 정수를 사용할 수 있습니다.

- `nodes`

    -암호없이 키를 만듭니다.

- `subj`
    - CSR(인증서 서명 요청)을 미리 형식에 맞춰서 입력할 수 있음.

    [CSR ( 인증서 서명 요청 ) 항목 ](https://www.notion.so/d984060648d34e87b2fc74d4f138e19a)

- `out localhost.dev.crt`
    - 새로 생성 된 인증서를 쓸 파일 이름을 지정합니다.

        모든 파일 이름을 지정할 수 있습니다.

- `keyout localhost.dev.key`
    - 새로 생성 된 개인 키를 쓸 파일 이름을 지정합니다.

        모든 파일 이름을 지정할 수 있습니다.

[https://blog.naver.com/skinfosec2000/222135874222](https://blog.naver.com/skinfosec2000/222135874222)

[https://blusky10.tistory.com/352](https://blusky10.tistory.com/352)

[https://linuxize.com/post/creating-a-self-signed-ssl-certificate/](https://linuxize.com/post/creating-a-self-signed-ssl-certificate/)

## Php-fpm 설정

- **php란?**

    대표적인 **서버 사이드 스크립트 언어**.

- **CGI(공통 게이트웨이 인터페이스) 란?**

    nginx는 웹서버이기 때문에 정적 콘텐츠밖에 다루지 못한다. 동적 페이지를 구현하기 위해서는 웹 서버 대신 동적 콘텐츠를 읽은 뒤 html로 변환시켜 웹 서버에게 다시 전달해주는 **외부 프로그램(php 모듈)**이 필요하다. 이런 **연결 과정의 방법 혹은 규약을 정의한 것이 CGI**이다.

- **php-fpm (PHP FastCGI Process Manager) 란?**

    일반 GCI 보다 빠른 처리가 가능한 FastGCI. 정리하자면, `php-fpm` 을 통해 **nginx와 php를 연동시켜 우리의 웹 서버가 정적 콘텐츠 뿐만 아니라 동적 콘텐츠를 다룰 수 있도록** 만드는 것이다.

```bash
apt-get install php-fpm
```

php-fpm 7.3 버전을 설치해주고 nginx default 파일에 php 처리를 위한 설정을 추가한다.

## nginx에 Autoindex & SSL & php-fpm 설정

Default 파일에 https 연결을 위한 설정을 작성한다. 원래는 서버 블록이 하나이며 80번 포트만 수신대기 상태인데, https 연결을 위해 443 포트를 수신대기하고 있는 서버 블록을 추가로 작성해야 한다.

### default.conf

```
server {
	listen 80;
	listen [::]:80;
	
	return 301 https://$host$request_uri;
}

server {
	listen 443 ssl;
	listen [::]:443 ssl;

	# ssl setting
	ssl on;
	ssl_certificate /etc/ssl/certs/localhost.dev.crt;
	ssl_certificate_key /etc/ssl/private/localhost.dev.key;

	# Set root dir of server
	root /var/www/html;

	# Autoindex
	index index.html index.htm index.php #index.ngiinx-debian.html;

	server_name ft_server;

	location / {
		autoindex on;
		try_files $uri $uri/ =404;
	}

	# PHP - php7.3-fpm
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
	}
}
```

### Redirecting all HTTP traffic to HTTPS

```
server {
	listen 80;
	listen [::]:80;
	
	return 301 https://$host$request_uri;
}
```

- server - 코드가 작성된 블록의 이름이다.
- 80 default_server를 수신합니다. -포트 번호 80은 "http"포트이고 default_server는 서버의 호스트 이름입니다. 이는 서버에서 발생한 모든 IPv4 HTTP 패킷을 리디렉션하기위한 것이다.
- listen [::]:80 default_server; - 수신 [::] : 80 default_server; -이 라인은 위와 동일하지만 모든 IPv6 HTTP 트래픽에 대해 작동한다.
- return 301 https://$host$request_uri; - 코드 "301"은 트래픽을 리디렉션하는 데 사용됩니다. "https : // $ host $ request_uri;" 모든 트래픽이 리디렉션되는 대상이다.

### Autoindex & try_files setting

```
	# Autoindex
	index index.html index.htm index.php #index.ngiinx-debian.html;

	server_name ft_server;

	location / {
		autoindex on;
		try_files $uri $uri/ =404;
	}
```

  웹 사이트를 몇 개 설정 한 후에는 항상이 문제를 마주치며 제대로 될 때까지 무작위로 추측하고 시도해야합니다. 그래서 그것을 변경하고 잘못된 URL에서 작동하는 404 페이지를 try_files 사용하여 지시문과 autoindex on을 이용해서 자동 디렉토리 색인을 사용하여 nginx를 구현하는 적절한 방법을 이해합시다.

### 정확히 uri 일치하는 경우

- index.html이 있는 경우 표시

```
index index.html
```

포인트는 내장 nginx 지시문을 사용하여 구현된다.

- {url}.html이 있는 경우 표시
- 폴더가있는 경우 자동화 된 디렉토리 표시
- 그렇지 않으면 404 오류가 표시됩니다.

```
autoindex on;
try_files $uri $uri.html $uri/ =404;
```

나머지 시나리오는 다음을 사용하여 구현된다.

조건 중 하나가 충족 될 때까지 순서대로 확인된다.

[https://computableverse.com/blog/nginx-autoindex-try-files](https://computableverse.com/blog/nginx-autoindex-try-files)

[https://www.psychz.net/client/question/ko/nginx-redirect-http-to-https.html](https://www.psychz.net/client/question/ko/nginx-redirect-http-to-https.html)

### php-fpm

```
	# PHP - php7.3-fpm
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
	}
```

 설치한 php7.3-fpm php 처리를 위한 설정이다.

# 6. Wordpress

   **Wordpress**는 템플릿 시스템을 사용한다. PHP와 HTML 코드 수정 없이도 다시 정리할 수 있는 위젯이 포함되어 있고, 테마도 설치해 자유롭게 전환할 수 있다. 테마 안의 PHP와 HTML 코드는 좀 더 세분화된 맞춤 페이지를 위해 편집할 수 있다.

### 권한 설정

```bash
chown www-data:www-data  -R * # Let Apache be owner
chmod -R 755 ../../var/www
```

- WP를 설정할 때 (웹 서버) 파일에 대한 쓰기 권한이 필요할 수 있다. 따라서 액세스 권한은 느슨하게 할 필요가 있다.
- nginx.conf를 보면 user로 www-data가 작성되어있다. wordpress의 유저 그룹을 그에 맞게 설정해준 것이다.

### wordpress 설치

```bash
tar -xvf latest.tar.gz
mv wordpress/ var/www/html/
```

나는 빠른 설치를 위해 최신 버전을 미리 받아두고 실행을 할 수 있도록 했다.

[https://code-examples.net/ko/q/1180a2a](https://code-examples.net/ko/q/1180a2a)

### wp-config.php 파일 수정

`wp-config-sample.php` 을 복사해 `wp-config.php` 를 만든다.

```bash
cp -rp var/www/html/wordpress/wp-config-sample.php var/www/html/wordpress/wp-config.php
```

`wp-config.php` 파일의 DB_NAME, DB_USER, DB_PASSWORD 3가지 항목을 수정해준다.

```bash
vim var/www/html/wordpress/wp-config.php
```

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/21f98d76-077c-426e-a9ce-059e852fcdcc/_2021-04-16__4.35.31.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/21f98d76-077c-426e-a9ce-059e852fcdcc/_2021-04-16__4.35.31.png)

### wordpress를 위한 DB 테이블 생성

### **db 설정을 위해 mysql을 실행**

```
service mysql start
```

### mysql 접속 및 DB 생성

```sql
mysql # 실행시키면 mysql로 들어가짐

CREATE DATABASE wordpress;
# `;` 꼭 입력하기;
```

### 유저 생성

```sql
# on mysql
CREATE USER 'kyulee'@'localhost' IDENTIFIED BY 'kyulee';
GRANT ALL PRIVILEGES ON wordpress.* TO 'kyulee'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

`@'localhost'` 는 로컬 접속만 허용하겠다는 뜻이고 `@'%'`로 작성하면 외부 접속을 허용하겠다는 뜻이다.

FLUSH PRIVILEGES : grant 테이블을 reload함으로서 변경 사항을 즉시 반영하도록 한다.

### 유저 정보 확인

```sql
USE mysql;
select user, host from user;
```

### 테이블 생성 확인

```sql
# on mysql
USE wordpress;
SHOW TABLES;
```

`exit` 로 mysql을 빠져나올 수 있다.

### php7.3-fpm 재시작

```
service php7.3-fpm restart
```

php-mysql로 php 설정이 변경되었기 때문이다.

# phpMyAdmin

### phpmyadmin

```bash
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
```

 압축 해제 후 폴더 이름을 **phpmyadmin** 으로 바꿔서 우리 서버의 루트 디렉토리(**/var/www/html**)에 위치시킨다.

### phpmyadmin을 위한 DB테이블 생성

db 설정을 위해 mysql을 실행시킨다.

```
service mysql start
```

phpmyadmin/sql 폴더의 `create_table.sql` 파일을 mysql로 리다이렉션 시켜준다.

```
mysql < var/www/html/phpmyadmin/sql/create_tables.sql
```

### phpMyAdmin blowfish

phpMyAdmin을 업로드 하고 로그인 했을 때 다음과 같은 문구가 나오는 경우가 있습니다.

**blowfish** : 1993년 브루스 슈나이어가 설계한 키(key) 방식의 대칭형 블록 암호이다. 64비트 블록 크기, 또 32비트에서 최대 448비트에 이르는 가변 키 길이를 갖추고 있다.

[https://ko.wikipedia.org/wiki/블로피시](https://ko.wikipedia.org/wiki/%EB%B8%94%EB%A1%9C%ED%94%BC%EC%8B%9C)

### config.inc.php

```php
$cfg['blowfish_secret'] = ''; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
```

위와 같이 blowfish_sercet code를 입력하면 사용하면 된다.

[https://phpsolved.com/phpmyadmin-blowfish-secret-generator/](https://phpsolved.com/phpmyadmin-blowfish-secret-generator/)

참고

[https://www.popit.kr/개발자가-처음-docker-접할때-오는-멘붕-몇가지/](https://www.popit.kr/%EA%B0%9C%EB%B0%9C%EC%9E%90%EA%B0%80-%EC%B2%98%EC%9D%8C-docker-%EC%A0%91%ED%95%A0%EB%95%8C-%EC%98%A4%EB%8A%94-%EB%A9%98%EB%B6%95-%EB%AA%87%EA%B0%80%EC%A7%80/)
