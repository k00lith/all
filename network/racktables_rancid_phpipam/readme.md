### Установка RackTables, Rancid, PHPiPAM на сервер CentOS7 x64 minimal


#### 1. Начало:

```bash
yum update
yum install epel-release
yum update
yum -y install net-tools.x86_64 mc vim wget gzip mlocate
updatedb
```

#### 2. Отключаем SELINUX
```bash
mcedit /etc/sysconfig/selinux
SELINUX=disabled
```
#### 3. Чтобы изменения вступили в силу, перезагружаемся.

#### 4. Отключаем firewalld:
```bash
systemctl stop firewalld
systemctl disable firewalld
```
```bash
yum -y install iptables-services
systemctl enable iptables.service 
systemctl start iptables.service
```
```bash
vim /root/iptables-rules
```

#### 5. Добавляем правила отсюда:
https://github.com/k00lith/all/tree/master/linux/iptables
```bash
cd /root/
iptables-restore < iptables-rules
service iptables save
```
#### 6. Ставим апач

```bash
yum install httpd -y
systemctl enable httpd
systemctl start httpd
```

#### 7. Проверяем в браузере
http://192.168.1.1
(если не открывается - проверить в iptables доступ)

#### 8. Ставим SSL ссльный мод:
```bash
yum install mod_ssl -y
```
#### 9. Создаем дериктории под ключи:
```bash
mkdir -p /etc/httpd/ssl/private
chmod 700 /etc/httpd/ssl/private
```

#### 10. Создаем сертификат:
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/httpd/ssl/private/apache-selfsigned.key -out /etc/httpd/ssl/apache-selfsigned.crt
```
#### 11. Далее проходим простенький мастер создания сертификата


#### 12. Ставим SQL
Для этого создаем файл /etc/yum.repos.d/mariadb.repo следующего содержания:
```bash
[mariadb]
name = MariaDB
baseurl = https://mirror.mariadb.org/yum/10.8.4/centos7-amd64/
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
```
```bash
yum update
yum install MariaDB-server MariaDB-client -y
systemctl start mariadb
systemctl enable mariadb.service
```
Запускаем скрипт начальной настройки (тут не забываем поставить пароль на рута sql):
```bash
mariadb-secure-installation
```

#### 13. ОПТИМИЗАЦИЯ БАЗ ДАННЫХ ПО КРОНУ

```bash
mysql -uroot –p
MariaDB [(none)]> show databases;
```

Это когда у нас уже есть базы, которые нужно оптимизировать

Делаем несколько заданий в кронтабе
```bash
[root@zabbix ~]# crontab -e
05 01 * * * /root/mysql_optimaze1
35 01 * * * /root/mysql_optimaze2
```

Первый скрипт - тут одна база указана, а можно все, чуть ниже
```bash
vim /root/mysql_optimaze1
#!/bin/sh
mysqlcheck -uroot -pPassword -o zabbix_db
```
Для всех 
```bash
mysqlcheck -uroot -pPassword --all-databases
```

Второй скрипт
```bash
vim /root/mysql_optimaze2
#!/bin/sh
mysqlcheck -u root -pPassword --auto-repair --check --all-databases
```
```bash
chmod u+x /root/mysql_optimaze1
chmod u+x /root/mysql_optimaze2
```
```bash
[root@zabbix ~]# crontab -l
05 01 * * * /root/mysql_optimaze1 
35 01 * * * /root/mysql_optimaze2
```


#### 14. СТАВИМ РАКТЭЙБЛС
```bash
mysql -uroot -p
```
```bash
> create database racktables;
> grant all privileges on racktables.* TO 'root'@'localhost' identified by 'qyaZY77lol';
> flush privileges;
> quit
```

#### 15. Создаем пользователя и домашнюю папку:
```bash
useradd -s /sbin/nologin -c "rackadmin" -m -d /home/racktables racktables
```

#### 16. Ставим mbstring
```bash
yum install php-mbstring -y
```
#### 17. Ставим bcmath
```bash
yum install php-bcmath -y
```
#### 18. Ставим snmp
```bash
yum -y install net-snmp net-snmp-utils
```

#### 19. Установка PHP (скопировал из интернета неплохую статью):
Версия PHP, которая поставляется с CentOS по умолчанию, довольно старая (PHP 5.4). Поэтому в этой главе я покажу вам некоторые варианты установки более новых версий PHP, таких как PHP 7.0 - 7.3, из репозитория Remi.

Добавьте репозиторий Remi CentOS.
```bash
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
```
Установите yum-utils так, как нам нужна утилита yum-config-manager.
```bash
yum -y install yum-utils
```
и запустите yum update
```bash
yum update
```
Теперь вам нужно выбрать, какую версию PHP вы хотите использовать на сервере. Если вам нравится использовать PHP 5.4, перейдите к главе 4.1. Чтобы установить PHP 7.0, следуйте командам в главе 4.2, для PHP 7.1 - главе 4.3, для PHP 7.4 используйте главу 4.4, а для PHP 7.3 - вместо главы 4.5. Следуйте только одной из глав 4.x, а не всем, поскольку вы можете использовать только одну версию PHP одновременно с Apache mod_php.

4.1 Установите PHP 5.4
Чтобы установить PHP 5.4, выполните эту команду:
```bash
yum -y install php
```
4.2 Установить PHP 7.0
Мы можем установить PHP 7.0 и модуль Apache PHP 7.0 следующим образом:
```bash
yum-config-manager --enable remi-php70
yum -y install php php-opcache
```
4.3 Установить PHP 7.1
Если вы хотите использовать PHP 7.1 вместо этого, используйте:
```bash
yum-config-manager --enable remi-php71
yum -y install php php-opcache
```
4.4 Установите PHP 7.2
Если вы хотите использовать PHP 7.2 вместо этого, используйте:
```bash
yum-config-manager --enable remi-php72
yum -y install php php-opcache
```
4.5 Установите PHP 7.3
Если вы хотите использовать PHP 7.3, используйте:
```bash
yum-config-manager --enable remi-php73
yum -y install php php-opcache
yum install php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -y
```
В этом примере и в загружаемой виртуальной машине я буду использовать PHP 7.3.

Мы должны перезапустить Apache, чтобы применить изменения:
```bash
systemctl restart httpd.service
```

#### 20. Ставим RACKTABLES:
```bash
cd /usr/src/
wget https://sourceforge.net/projects/racktables/files/RackTables-0.22.0.tar.gz --no-check-certificate
tar zxvf Rack*
cp -rf RackTables-0.22.0 /var/www/html/racktables
chown -R racktables:racktables /var/www/html/racktables
```

Добавляем в конфиг апача  виртуал хост:
```bash
vim /etc/httpd/conf.d/vhosts.conf
```
```bash
<VirtualHost 192.168.23.137:443>
        AddType application/x-httpd-php .php
        AddType application/x-httpd-php-source .phps

        ErrorLog logs/ssl_error_log
        TransferLog logs/ssl_access_log
        LogLevel warn
        SSLEngine on
        SSLProtocol all -SSLv2 -SSLv3
        SSLCipherSuite HIGH:3DES:!aNULL:!MD5:!SEED:!IDEA
        SSLCertificateFile /etc/httpd/ssl/apache-selfsigned.crt
        SSLCertificateKeyFile /etc/httpd/ssl/private/apache-selfsigned.key
        <Directory /var/www/html/racktables/wwwroot/>
                DirectoryIndex index.php
                Require all granted
        </Directory>
        Alias /racktables /var/www/html/racktables/wwwroot/
</VirtualHost>
```
```bash
systemctl restart httpd
```
#### 21. Вспомогательный файл:
```bash
touch /var/www/html/racktables/wwwroot/inc/secret.php
chmod a=rw /var/www/html/racktables/wwwroot/inc/secret.php
```
#### 22. Переходим по ссылке на веб-интерфейс (у нас уже по ssl):
```bash
https://192.168.23.137/racktables/?module=installer
```
#### 23. Далее в процессе утсановки нужно будет выполнить команду:
```bash
chown apache:apache /var/www/html/racktables/wwwroot/inc/secret.php; chmod 440 /var/www/html/racktables/wwwroot/inc/secret.php
```
И, там же в мастере, установить пароль.

#### 24.После установки вэб-интерфейс доступен по адресу (не забыть про правила iptables):
```bash
https://192.168.13.245/racktables/
```


