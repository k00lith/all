### SQL CHECK

Для обслуживания баз (-ы), желательно выполнять следующие задания

(через crone, например)


Первый:

```
#!/bin/sh
mysqlcheck -uroot -pPa$$w0rd -o zabbix_db
```
 или

```
#!/bin/sh
mysqlcheck -uroot -pPa$$w0rd --all-databases
``` 


Второй:

```
#!/bin/sh
mysqlcheck -u root -pPa$$w0rd --auto-repair --check --all-databases
```

Делаем тип файла экзекьютбл
```
chmod +x mysql_optimaze1
chmod +x mysql_optimaze2
```

Задание в CRON:

```
### SQL OPTIMAZED
05 02 * * * /root/mysql_optimaze1
35 02 * * * /root/mysql_optimaze2
```
