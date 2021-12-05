### TIMER UNIT ###

Описание: создадим службу, которая будет запускать скрипт python по расписанию (альтернатива cron)

Дано: 
- сркипт /var/refresh_spare_srx_config.py 
- скрипт запускаемый chmod +x

Создаем юнит, который будет запускать скрипт
```shell
vim /usr/lib/systemd/system/refresh_srx.service
```
Содержание:
```shell
[Unit]
Description=Refresh combat config of spare SRX

[Service]
Type=simple
ExecStart=/usr/local/bin/python3.7 '/var/refresh_spare_srx_config.py'

[Install]
WantedBy=multi-user.target
```
Создание таймера
```shell
vim /usr/lib/systemd/system/refresh_config.timer
```
Содержание:
```shell
[Unit]
Description=Execute every day at 04:00

[Timer]
OnCalendar=*-*-* 04:00:00
Unit=refresh_srx.service

[Install]
WantedBy=multi-user.target
```

#### Проверка ####
Активируем загрузку и запустим сервис:

```shell
systemctl enable refresh_config.timer
systemctl start refresh_config.timer
```

Для проверки автозапуска:

```shell
systemctl is-enabled refresh_config.timer
enabled
```
Для проверки запуска таймера:

```shell
systemctl is-active refresh_config.timer
active
```
Если необходимо, сервис можно запустить вручную в любое время:

```shell
systemctl start refresh_config
```
Если были внесены какие-то изменение в таймер, например время выполнения, то необходимо произвести обновление сервиса:

```shell
systemctl daemon-reload
```
Просмотр таймеров в системе

```shell
systemctl list-timers refresh_config*
```

