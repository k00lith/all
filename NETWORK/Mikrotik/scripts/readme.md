Скрипт постоянного пинга определенного хоста с определенного адреса микротика

```mikrotik
:local pingcount 1;
:local dest 192.168.7.1;
:local source 192.168.11.10;
:local pingresultA [/ping $dest src-address=$source  count=$pingcount];
:log info $pingresultA;
```
:log info $pingresultA; - необязательно, для проверки, вывод результата в лог

![alt text](scripts/pic/111.png "scr")
