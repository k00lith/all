#### UDP scan port

```
nmap -sU -p 27539 8.8.8.8
```


Если соединение удачно, то увидим такой ответ:

```
#nmap -sU -p U:53 11.1.11.12
PORT   STATE         SERVICE
53/udp open|filtered domain
```

или

```
PORT   STATE SERVICE
53/udp open  domain
Nmap done: 1 IP address (1 host up) scanned in 0.65 seconds
```

Если же неудачное, то такое:

```
#nmap -sU -p U:53 11.1.11.13
PORT   STATE  SERVICE
53/udp closed domain
```



#### Сканирование с базой уязвимостей

Установка на Ubuntu 22 и сканирование:
```
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install nmap
sudo nmap --script-updatedb
sudo nmap --script vuln 1.1.1.1 -p 25,80,465,587,993,995,8443,8291 -v
sudo nmap --script vuln 1.1.1.1 -p 8291 -v
sudo nmap --script vuln 1.1.1.1 -p 80,443 -v
```

#### Вариант сканирования
```
sudo nmap --min-parallelism 100 -sT -sU 1.1.1.0/24
```

