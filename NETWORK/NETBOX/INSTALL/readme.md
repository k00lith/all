### INSTALL NETBOXv3 on CentOS7
------------------------------------------

#### BRIEFLY:

1.  PREPARE CentOS7 VM
2.  UPDATE SYSTEM
3.  REBOOT
4.  INSTALL TOOLS
5.  DISABLE SELINUX
6.  REBOOT
7.  DISABLE firewalld
8.  INSTALL iptables
9.  MAKE iptables RULES
10. INSTALL PostgreSQL
11. CREATE DATABASE
12. VERIFY SERVICE STATUS
13. REDIS INSTALL
14. PYTHON INSTALL
15. GET NETBOX FROM GIT
15. CONFIG NETBOX
16. GENERATE SECRET KEY
17. PASTE KEY IN configuration.py FILE
18. ADD DEPENDENSES
19. RUN UPGRADE NETBOX SCRIPT
20. CHECK APP
21. INSTALL GUNICORN
22. ADD SSL
23. INSTALL APACHE
24. PERMIT TCP-80,8045 IN IPTABLES
25. CHECK APACHE IN BROWSER
26. EDIT NETBOX SITE CONFIG
27. RESTART APACHE
28. GO TO NETBOX WEB

DONE!

------------------------------------------

#### DETAILED:

1.  PREPARE CentOS7 VM:

2.  UPDATE SYSTEM:
```
yum  update -y
```

3.  REBOOT:
```
shutdown -r now
```
4.  INSTALL TOOLS:
```
yum install -y epel-release
yum  update -y
yum install -y mc wget gzip vim htop net-tools mlocate
updatedb
```
5.  DISABLE SELINUX:
```
mcedit /etc/sysconfig/selinux
SELINUX=disabled
```
6.  REBOOT:
```
shutdown -r now
```

7.  DISABLE firewalld:
```
systemctl stop firewalld
systemctl disable firewalld
```

8.  INSTALL iptables:
```
yum -y install iptables-services
systemctl enable iptables.service 
systemctl start iptables.service
```

9.  MAKE iptables FILE IN root DIR (for example)

RULES:

https://github.com/k00lith/ALL/blob/master/LINUX/IPTABLES/readme.md

```
cd /root/
vi /root/iptables-rules
iptables-restore < iptables-rules
service iptables save
```

Check:
```
iptables -n -L -v --line-numbers
```
10. INSTALL PostgreSQL:
```
yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y
yum update
yum install postgresql13 postgresql13-server postgresql13-contrib postgresql13-libs
/usr/pgsql-13/bin/postgresql-13-setup initdb
systemctl start postgresql-13
systemctl enable postgresql-13
systemctl status postgresql-13
```

11. CREATE DATABASE:
```
sudo -u postgres psql
```
```
CREATE DATABASE netbox;
CREATE USER netbox WITH PASSWORD 'J5brHrAXFLQSif0K';
GRANT ALL PRIVILEGES ON DATABASE netbox TO netbox;
```
Exit:
```
\q
```

12. VERIFY SERVICE STATUS:
```
psql --username netbox --password --host localhost netbox
```

13. REDIS INSTALL:
```
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum update
yum --enablerepo=remi install redis -y
systemctl start redis
systemctl enable redis
redis-cli ping
```

14. PYTHON INSTALL:
```
yum install -y gcc libxml2-devel libxslt-devel libffi-devel libpq-devel openssl-devel redhat-rpm-config zlib-devel
cd /usr/src 
wget https://www.python.org/ftp/python/3.7.5/Python-3.7.5.tgz
tar xzf Python-3.7.5.tgz
cd Python-3.7.5 
./configure --prefix=/usr  --enable-optimizations
make
make install
rm /usr/src/Python-3.7.5.tgz
pip3 install --upgrade pip
```

15. GET NETBOX FROM GIT
```
mkdir -p /opt/netbox/ 
cd /opt/netbox/
yum install -y git
git clone -b master --depth 1 https://github.com/netbox-community/netbox.git .

groupadd --system netbox
adduser --system -g netbox netbox
chown --recursive netbox /opt/netbox/netbox/media/
```

15. CONFIG NETBOX:
```
cd /opt/netbox/netbox/netbox/
cp configuration.example.py configuration.py
mcedit configuration.py 
```

Change - ALLOWED_HOSTS = ['*'] , DATABASE, USER


16. GENERATE SECRET KEY:
```
python3.7 ../generate_secret_key.py
```

17. PASTE KEY IN configuration.py FILE
```
mcedit configuration.py 
```

18. ADD DEPENDENSES
```
sh -c "echo 'napalm' >> /opt/netbox/local_requirements.txt"
sh -c "echo 'django-storages' >> /opt/netbox/local_requirements.txt" 
```

19. RUN UPGRADE NETBOX SCRIPT:
```
/opt/netbox/upgrade.sh 
source /opt/netbox/venv/bin/activate
cd /opt/netbox/netbox
python3 manage.py createsuperuser
cp /opt/netbox/contrib/netbox-housekeeping.sh /etc/cron.daily/
```

20. CHECK APP:
```
python3 manage.py runserver 0.0.0.0:8000 --insecure
```
21. INSTALL GUNICORN:
```
cp /opt/netbox/contrib/gunicorn.py /opt/netbox/gunicorn.py
cp -v /opt/netbox/contrib/*.service /etc/systemd/system/
systemctl daemon-reload
systemctl start netbox netbox-rq
systemctl enable netbox netbox-rq
systemctl status netbox.service
```

22. ADD SSL:
```
mkdir /etc/ssl/private/
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/netbox.key -out /etc/ssl/certs/netbox.crt
```

23. INSTALL APACHE:
```
yum install httpd mod_ssl -y
systemctl enable httpd
systemctl start httpd
```
24. PERMIT TCP-80,8045 IN IPTABLES:
```
cd /root/
vi /root/iptables-rules
iptables-restore < iptables-rules
service iptables save
```
25. CHECK APACHE IN BROWSER:

http://OUR-IP-ADDRESS

26. EDIT NETBOX SITE CONFIG: 
```
cp /opt/netbox/contrib/apache.conf /etc/httpd/conf.d/netbox.conf
vi /etc/httpd/conf.d/netbox.conf
```

ADD THIS TO FILE netbox.conf
```
Listen 8045
<VirtualHost *:*>
ProxyPreserveHost On
ServerName 192.168.53.64
SSLEngine on
SSLCertificateFile /etc/ssl/certs/netbox.crt
SSLCertificateKeyFile /etc/ssl/private/netbox.key
Alias /static /opt/netbox/netbox/static
<Directory /opt/netbox/netbox/static>
Options Indexes FollowSymLinks MultiViews
AllowOverride None
Require all granted
</Directory>
<Location /static>
ProxyPass !
</Location>
ProxyPass / http://127.0.0.1:8001/
ProxyPassReverse / http://127.0.0.1:8001/
</VirtualHost>
```

27. RESTART APACHE:
```
systemctl restart httpd
```

28. GO TO NETBOX WEB:


https://OUR-IP-ADDRESS:8045

