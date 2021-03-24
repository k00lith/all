### Установка zabbix-agent на CentOS7 ###

---

Предварительно:

```shell
yum clean all
yum makecache
yum update
yum search zabbix
```

Ставим (например нашли просто zabbix-agent, есть еще более специфичные - zabbix-agent_44 или что-то в этом роде)

```shell
yum install zabbix-agent
```

Настройка
```shell
vi /etc/zabbix/zabbix_agentd.conf
```

Указываем сервер мониторинга 
```shell
Server=172.17.16.1
```

Настройка iptables на хосте
```shell
iptables -I INPUT 1 -p tcp --dport 10050 -j ACCEPT
```
Сохраняем:
```shell
service iptables save
```

Запускаем агент:

```shell
systemctl enable zabbix-agent
systemctl start zabbix-agent
systemctl status zabbix-agent
```

