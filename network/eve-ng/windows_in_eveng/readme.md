УСТАНОВКА:

0. Включить виртуальную машину EVE-NG

1. Открыть Bitvise SSH Client

2. Пройти процедуру аутентификации:
	ip-адресс: [какой указан в виртуальной машине EVE-NG]
	пользователь: root
	пароль: eve


В SFTP:

3. Перейти в каталог /opt/unetlab/addons/qemu и создать папку "winserver-*"

4. Добавить в созданную папку образ Windows - *.iso

5. Переименовать образ Windows в cdrom.iso


В Терминале:

6. 	Перейти в нужную директорию командой:
		cd /opt/unetlab/addons/qemu/winserver-*

7.	Создать виртуальный жесткий диск:
		/opt/qemu/bin/qemu-img create -f qcow2 virtioa.qcow2 35G


В веб-интерфейсе EVE-NG:

8. Добавить объект Windows Server, запустить и начать установку Windows

9. Установить ПРАВИЛЬНО!!! Windows
	Выбрать Floppy Drive, FDD B/storage/2003R2/AMD64


В Терминале:

10. Сделать текущее состояние ВМ по умолчанию:
	Перейти cd /opt/unetlab/tmp/0/[id лабораторки]/[id объекта]
	Выполнить команду - /opt/qemu/bin/qemu-img commit virtioa.qcow2


В SFTP: 

11. Удалить cdrom.iso
