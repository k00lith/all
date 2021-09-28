### SQL CHECK

Для обслуживания баз (-ы), желательно выполнять следующие задания

(через crone, например)


Первый:

```
#!/bin/sh
mysqlcheck -uroot -pPa$$w0rd -o zabbix_db
```

Второй:

```
#!/bin/sh
mysqlcheck -u root -pPa$$w0rd --auto-repair --check --all-databases
```
