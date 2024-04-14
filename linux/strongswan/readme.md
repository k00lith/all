Пример рабочего конфига между Qtech QSR-1920-12-AC и CentOS7

Конфиг strongswan
```
cat /etc/strongswan/ipsec.conf

conn centos-to-qtech
       authby=secret
       leftid=5.5.5.5
       leftsubnet=192.168.0.0/24
       right=4.4.4.4
       rightsubnet=192.168.10.0/24
       ike=aes256-sha2_256-modp1024!
       esp=aes256-sha1!
       keyexchange=ikev1
       keyingtries=%forever
       closeaction=restart
       lifetime=8h
       dpddelay=30
       dpdtimeout=120
       dpdaction=restart
       auto=start
       fragmentation = yes
       type = tunnel
```
Ключ
```
cat /etc/strongswan/ipsec.secrets

5.5.5.5 4.4.4.4 : PSK "тут_ключ_набор_символов"
```

Конфиг Qtech
```
crypto ike key тут_ключ_PSK_набор_символов address 5.5.5.5

crypto ike proposal ikepro
 encryption aes256
 integrity sha2-256
 group group2
 exit

crypto ipsec proposal ippro
 esp aes256 sha1
 exit

crypto tunnel TUN_IPSEC
 local address 4.4.4.4
 peer address 5.5.5.5
 set authentication preshared
 set ike proposal ikepro
 set ipsec proposal ippro
 exit
 
crypto policy IPSEC_POLICY
 flow 192.168.0.0 255.255.255.0 192.168.10.0 255.255.255.0 ip ipv4-tunnel TUN_IPSEC
 exit
```
