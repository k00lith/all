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
