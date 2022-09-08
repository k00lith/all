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


### RANCID + ViewVC:

#### 1. Ставим вспомогательные пакеты:
```bash
yum install cvs expect gcc MySQL-python telnet wget -y
```
#### 2. Далее, качаем и распаковываем:
```bash
mkdir /root/src/
cd /root/src/
wget ftp://ftp.shrubbery.net/pub/rancid/rancid-3.13.tar.gz
tar -zxvf rancid-*
cd /root/src/rancid-3.13
```
#### 3. Добавляем группу netadm в которую впоследствии будет добавлен пользователь apache.
```bash
groupadd netadm
```
#### 4. Создаем пользователя rancid и задаем ему пароль.
```bash
useradd -g netadm -d /home/rancid rancid
passwd rancid
```
#### 5. Компилируем и устанавлваем rancid.
```bash
pwd	
cd /root/src/rancid-3.13
./configure --prefix=/home/rancid
make install
```
#### 6. Копируем файл в котором будут содержаться пароли от сетевого оборудования и выставляем права.
```bash
cp /root/src/rancid-3.13/cloginrc.sample /home/rancid/.cloginrc
chmod 0640 /home/rancid/.cloginrc
chown -R rancid:netadm /home/rancid/
chmod 770 /home/rancid/
```
#### 7. В файле rancid.conf определяем группы сетевого оборудование. Все дальнейшие изменения в файлах надо делать от пользователся rancid.

```bash
cp /home/rancid/etc/rancid.conf /home/rancid/etc/rancid.conf.orig
cd /home/rancid/
su rancid
vim /home/rancid/etc/rancid.conf
```
Содержание:
```bash
...
# list of rancid groups
#LIST_OF_GROUPS="sl joebobisp"
# more groups...
#LIST_OF_GROUPS="$LIST_OF_GROUPS noc billybobisp"

LIST_OF_GROUPS="juniper hp"

#
...
```

#### 8. Создаем CVS репозиторий для ранее определенных групп.
```bash
/home/rancid/bin/rancid-cvs
```

#### 9. Перечисляем оборудование с которого будем снимать конфигурацию.
```bash
vim /home/rancid/var/hp/router.db
```
Содержание:
```bash
...
hp1313;hp;up
srx-test;juniper;up
...
```
где:
srx-test - это имя устройства, как оно прописано в /etc/hosts. 
Или можно целиком написать url устройства.
juniper - тип устройсва. 
Для каждого типа rancid использует свои скритпы.
up - говорм rancid, что устройство работаем и можно пробовать снять конфиг.
Обращаем внимание, что в версиях rancid после 3.x в качестве разделителя используется “;”.

#### 10. Задаем пользователя, пароль и имя устройства (как в router.db) для захода на сетевое оборудование.
Файл читается до первого совпадения.
```bash
vim /home/rancid/.cloginrc
```
Содержание:
```bash
...
add method hp1313 ssh
add user hp1313 admin
add autoenable hp1313 1
add password hp1313 nimda
...
```

Примеры .cloginrc для различного оборудования:
Конкретный маршрутизатор Cisco. 
В строке пароля указывается пользовательский и enable пароль. 

```bash
add method CISCO-ROUTER-1 ssh
add user CISCO-ROUTER-1 USER-NAME
add password CISCO-ROUTER-1 USER-PASSWORD ENABLE-PASSWORD
```
Несколько маршрутизаторов Cisco можно записать через *. 

```bash
add method CISCO-ROUTER-* ssh
add user CISCO-ROUTER-* USER-NAME
add password CISCO-ROUTER-* USER-PASSWORD ENABLE-PASSWORD
```

У маршрутизаторов Juniper enable пароля нет, пишем только пользовательский пароль. 

```bash
add method SRX* ssh
add user SRX* USER-NAME
add password SRX* USER-PASSWORD
```

Для коммутаторов HP Procurve надо включать опцию autoenable. 

Пароль оператора и менеджера был одинаковый. 

```bash
add method PROCURVE-SW* ssh
add user PROCURVE-SW* USER-NAME
add autoenable PROCURVE-SW* 1
add password PROCURVE-SW* USER-PASSWORD
```

Настройка для маршрутизаторов Brocade CER. 

```bash
add method BROCADE-CER* ssh
add user BROCADE-CER* USER-NAME
add autoenable BROCADE-CER* 1
add password BROCADE-CER* USER-PASSWORD
```

Вручную запускаем rancid (от пользователя rancid) и проверяем, что конфигурация снялась.
(hp1313 доложен быть прописан в hosts)


##### Была ошибка (пустой файл конфы снимается): no matching cipher found, решение:
В фале /etc/ssh/ssh_config раскоментить две строки:
```bash
#   Port 22
#   Protocol 2
   Cipher 3des
   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-cbc,3des-cbc
#   MACs hmac-md5,hmac-sha1,umac-64@openssh.com,hmac-ripemd160
#   EscapeChar ~
```
```bash
/home/rancid/bin/rancid-run -r hp1313
[rancid@zzz configs]$ ll /home/rancid/var/hp/configs
total 4
drwxr-x--- 2 rancid netadm   51 Jan 21 15:15 CVS
-rw-r----- 1 rancid netadm 3972 Jan 21 15:15 hp1313
```

#### 11. Чтобы убрать пароли из конфигураций:
В конфигурационном файле:
```bash
/home/rancid/etc/rancid.conf
```
Раскоментить следующие строки:

```bash
# FILTER_PWDS determines which passwords are filtered from configs by the
# value set (NO | YES | ALL).  see rancid.conf(5).
FILTER_PWDS=ALL; export FILTER_PWDS

#
# if NOCOMMSTR is set to YES, snmp community strings will be stripped from the
# configs.

NOCOMMSTR=YES; export NOCOMMSTR

# FILTER_OSC determines if oscillating data such as keys, passwords, etc are
# filtered from configs by the value set (NO | YES).  FILTER_PWDS may override
# this.  see rancid.conf(5).

FILTER_OSC=YES; export FILTER_OSC

##
```

#### 12. Пишем правило cron для rancid.

```bash
crontab -e
```
```bash
# #############################################
# Crontab for rancid on myserver
# #############################################
# Hourly Check
1 * * * * /home/rancid/bin/rancid-run
# Daily Clean Up of Diff Files at 11 50 pm
50 23 * * * /usr/bin/find /home/rancid/var/logs -type f -mtime +2 -exec rm {} \;

# Daily Clean Up of .SITE.run.lock Files at 11 50 pm
50 23 * * * rm /tmp/.*.lock
```

#### 13. Отключение проверки ssh ключа

Для некоторых сетевых устройств полезно отключать проверку ssh т.к. на них часто могут меняться ключи. 
А когда устройств реально много, проще отключить проверку для всех.
Что бы откючить проверку надо в домашней директории rancid в папке .ssh создать файл config след. содержания:
```bash
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

### Установка ViewVC

#### 1. Скачиваем и распаковываем ViewVC. Version 1.1.26 (released 24-Jan-2017)

```bash
su root
cd /usr/src/
wget http://www.viewvc.org/downloads/viewvc-1.1.26.tar.gz
tar zxvf viewvc-*
cd viewvc-*
./viewvc-install
```

Настраиваем viewvc для работы с CVS репозиторием.
```bash
cd /usr/local/viewvc-1.1.26/
vim viewvc.conf
```

Вот эти опции нужно выставить:
```bash
cvs_roots = cvsroot: /home/rancid/var/CVS
root_parents = /home/rancid/var/CVS: cvs
rcs_dir = /usr/local/bin
use_rcsparse = 1
use_localtime = 1
allowed_views = annotate, diff, markup, roots, co
```
Далее по тексту они же:
```bash
...
## Example:
## cvs_roots = cvsroot: /opt/cvs/repos1,
## anotherroot: /usr/local/cvs/repos2
##
#cvs_roots =
cvs_roots = cvsroot: /home/rancid/var/CVS 
...
## Example:
## root_parents = /opt/svn: svn,
## /opt/cvs: cvs
##
#root_parents =
root_parents = /home/rancid/var/CVS: cvs
...
## Example:
## rcs_dir = /usr/bin/
##
#rcs_dir =
rcs_dir = /usr/local/bin
...
## use_rcsparse: Use the rcsparse Python module to retrieve CVS
## repository information instead of invoking rcs utilities [EXPERIMENTAL]
##
use_rcsparse = 1
...
## use_localtime: Display dates as UTC or in local time zone.
##
#use_localtime = 0
use_localtime = 1
...
#allowed_views = annotate, diff, markup, roots
allowed_views = annotate, diff, markup, roots, co
...
```

#### 2. Копируем файлы query.cgi и viewvc.cgi в рабочую папку веб-сервера.
```bash
cp /usr/local/viewvc-1.1.26/bin/cgi/*.cgi /var/www/cgi-bin
```
```bash
ll /var/www/cgi-bin

total 8
-rwxr-xr-x. 1 root root 1782 Feb 30 23:59 query.cgi
-rwxr-xr-x. 1 root root 1781 Feb 30 21:59 viewvc.cgi
```

 
#### 3. Чтобы закрыть доступ к странице viewvc – используем интсрументы самого апача:
```bash
htpasswd -c /etc/httpd/conf/.htpasswd-viewvc confadmin
New password:
Re-type new password:
Updating password for user confadmin
```

#### 4. Правим /etc/httpd/conf.d/vhosts.conf.

Копирую его в файл 1_vhosts.conf чтобы он первый в папке обрабатывался

Итого файл /etc/httpd/conf.d/1_vhosts.conf :

```bash
SSLPassPhraseDialog exec:/usr/libexec/httpd-ssl-pass-dialog
SSLSessionCache         shmcb:/run/httpd/sslcache(512000)
SSLSessionCacheTimeout  300
SSLRandomSeed startup file:/dev/urandom  256
SSLRandomSeed connect builtin
SSLCryptoDevice builtin

<VirtualHost 10.20.1.229:443>
    ErrorLog logs/ssl_error_log
    TransferLog logs/ssl_access_log
    LogLevel warn
    SSLEngine on
    SSLProtocol all -SSLv2 -SSLv3
    SSLCipherSuite HIGH:3DES:!aNULL:!MD5:!SEED:!IDEA
    SSLCertificateFile /etc/httpd/ssl/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/httpd/ssl/private/apache-selfsigned.key
    ScriptAlias /viewvc /var/www/cgi-bin/viewvc.cgi
    <Location /viewvc>
        Order deny,allow
        Allow from all
        Authtype Basic
        Authname "Password Required"
        AuthUserFile /etc/httpd/conf/.htpasswd-viewvc
        Require valid-user
    </Location>
    <Directory /var/www/html/racktables/wwwroot/>
        DirectoryIndex index.php
        Require all granted
    </Directory>
    Alias /racktables /var/www/html/racktables/wwwroot/
</VirtualHost>
```

#### 5. Далее делаем:
```bash
systemctl restart httpd.service
```

#### 6. Добавляем пользователя apache в группу netadm (тут у меня проблемы были помогло chmod -R 777 /home/, но это плохая команда). 

```bash
usermod -a -G netadm apache
```

#### 7. Создаем mysql базу данных и пользователей.
```bash
mysql -uroot –p
mysql> create database viewvc_db;
mysql> create user 'sqladm1'@'localhost' identified by 'LZ9fxocjhGOuVewMaR1A';
mysql> grant all privileges on viewvc_db.* to 'sqladm1'@'localhost' with grant option;
mysql> create user 'sqladm2'@'localhost' identified by 'RtQUNwR74ENhhsV7T4PV';
mysql> grant all privileges on viewvc_db.* to 'sqladm2'@'localhost' with grant option;
mysql> flush privileges;
```

#### 8. Заливаем структуру базы данных viewvc_db.
```bash
cd /usr/local/viewvc-1.1.26/bin/
./make-database
./make-database:20: DeprecationWarning: The popen2 module is deprecated.  Use the subprocess module.
  import popen2
MySQL Hostname (leave blank for default): 
MySQL Port (leave blank for default): 
MySQL User: sqladm1
MySQL Password: gbpltw
ViewVC Database Name [default: ViewVC]: viewvc_db
Database created successfully.  Don't forget to configure the [vsdb] section of your viewvc.conf file.
```

#### 8. Настраиваем viewvc для работы с mysql.

```bash
vim /usr/local/viewvc-1.1.26/viewvc.conf
```
Опции
```bash
enabled = 1
host = localhost
port = 3306
database_name = viewvc_db
user = sqladm1
passwd = gbpltw
readonly_user = sqladm2
readonly_passwd = gbpltw2
```
Далее по тексту:
```bash
...
[cvsdb]
## enabled: Enable database integration feature.
##
enabled = 1
## host: Database hostname.  Leave unset to use a local Unix socket
## connection.
##
host = localhost
## post: Database listening port.
##
port = 3306
## database_name: ViewVC database name.
##
database_name = viewvc_db
## user: Username of user with read/write privileges to the database
## specified by the 'database_name' configuration option.
##
user = sqladm1
## passwd: Password of user with read/write privileges to the database
## specified by the 'database_name' configuration option.
##
passwd = LZ9fxocjhGOuVewMaR1A
## readonly_user: Username of user with read privileges to the database
## specified by the 'database_name' configuration option.
##
readonly_user = sqladm2
## readonly_passwd: Password of user with read privileges to the database
## specified by the 'database_name' configuration option.
##
readonly_passwd = RtQUNwR74ENhhsV7T4PV
...
```


#### 9. НЗаполняем базу данных.

```bash
cd /usr/local/viewvc-1.1.26/bin/
./cvsdbadmin rebuild /home/rancid/var/CVS/CVSROOT/
Using repository root `/home/rancid/var/CVS'
Purging existing data for repository root `/home/rancid/var/CVS'
[CVSROOT/loginfo [0 commits]]
[CVSROOT/editinfo [0 commits]]
[CVSROOT/config [0 commits]]
[CVSROOT/notify [0 commits]]
[CVSROOT/verifymsg [0 commits]]
[CVSROOT/cvswrappers [0 commits]]
[CVSROOT/rcsinfo [0 commits]]
[CVSROOT/modules [0 commits]]
[CVSROOT/commitinfo [0 commits]]
[CVSROOT/checkoutlist [0 commits]]
[CVSROOT/taginfo [0 commits]]
```

#### 10. Делаем рестарт apache:
```bash
systemctl restart httpd
```
#### 11. Заходим по адресу, должна выскочить страница авторизации после принятия сертификата:
```bash
https://Х.Х.Х.Х:/viewvc
```



