CREATE DATABASE wordpress;
CREATE USER 'kyulee'@'localhost' IDENTIFIED BY 'kyulee';
GRANT ALL PRIVILEGES ON wordpress.* TO 'kyulee'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'kyulee'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;