##### Чтобы установить виртуалку в EVE-NG, т.е. чтобы пользоваться ей в лабах:


1. Подготовка директорий в еве:

```sh
cd /opt/unetlab/addons/qemu/
mkdir /opt/unetlab/addons/qemu/linux-CENTOS7
cd /opt/unetlab/addons/qemu/linux-CENTOS7
```

2. Закидываем образ на еву с помощью файлового менеджера в эту папку

3. Создаем виртуальный диск для машины:

```sh
/opt/qemu/bin/qemu-img create -f qcow2 hda.qcow2 15G
mv <тут имя исошника> cdrom.iso
```
4. Заходим на вэб евы:

5. Создаем лабу

6. Добавляем в топологию наш линукс:

```sh
Сетевуху выбираем (QEMU Nic)  - e1000
Подключаем к облаку - в облаке интерфейс Managment0
```

7. Стартуем виртуалку

8. Устанавливаем систему

9. Перед reboot идем в теримнал евы:

```sh
mv cdrom.iso centos-install.iso
```

10. Ребутимся

11. Ставим все нужные пакеты

12. Вырубаем виртуалку

13. Идем в вэб евы, вкладка LAB DETAILS, копируем ID

14. Идем в директорию (вместо непонятного набора символов должен быть наш ID выше)

```sh
cd /opt/unetlab/tmp/0/b437bf98-5b20-44b6-a9ca-f24e1360bc96/1/
/opt/qemu/bin/qemu-img commit hda.qcow2
cd /opt/unetlab/addons/qemu/linux-CENTOS7
/opt/unetlab/wrappers/unl_wrapper -a fixpermissions
```

Для CentOS7 минимал можно установить GUI и включать когда потребуется например браузер:

```sh
sudo yum -y groups install "GNOME Desktop"
echo "exec gnome-session" >> ~/.xinitrc
startx
```

Если нужно чтобы GUI стартовал автоматом после загрузки системы то

```sh
systemctl set-default graphical.target
```
(лучше запускать по необходимости, без автозагрузки)
