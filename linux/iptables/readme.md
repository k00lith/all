DISABLE firewalld:
```sh
systemctl stop firewalld
systemctl disable firewalld
```

INSTALL iptables:
```sh
yum -y install iptables-services
systemctl enable iptables.service 
systemctl start iptables.service
```

MAKE iptables FILE IN root DIR (for example)
```
cd /root/
vi /root/iptables-rules
```

ACTIVATE:

```sh
iptables-restore < /root/iptables-rules
service iptables save
```

Check:
```sh
iptables -n -L -v --line-numbers
```


#### RULES:

--------------------------------------
##### Attention! 
do not forget to change the name of the interface in the rules below to the real interface in the system. In this line:

```sh
-A OUTPUT -o enp0s3 -j ACCEPT
```

Example Config Rules:

```sh
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:undef_fw - [0:0]
:undef_in - [0:0]
:undef_out - [0:0]
# Фильтрация по именам сканеров
-I INPUT -p udp --dport 5060 -m string --string "friendly-scanner" --algo bm -j DROP
-I INPUT -p udp --dport 5060 -m string --string "sip-scan" --algo bm -j DROP
-I INPUT -p udp --dport 5060 -m string --string "sundayddr" --algo bm -j DROP
-I INPUT -p udp --dport 5060 -m string --string "iWar" --algo bm -j DROP
-I INPUT -p udp --dport 5060 -m string --string "sipsak" --algo bm -j DROP
-I INPUT -p udp --dport 5060 -m string --string "sipvicious" --algo bm -j DROP
# заблокировать нулевые пакеты
-A INPUT -p tcp --tcp-flags ALL NONE -j DROP
# отразить атаки syn-flood
-A INPUT -p tcp -m state --state NEW --tcp-flags SYN,ACK SYN,ACK -j REJECT --reject-with tcp-reset
-A INPUT -p tcp ! --syn -m state --state NEW -j DROP
# защита от разведывательных пакетов XMAS
-A INPUT -p tcp --tcp-flags ALL ALL -j DROP
#MORE-RULES
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -m state --state INVALID -j DROP
-A INPUT -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j DROP
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
#SSH
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -s 112.76.32.0/19 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -s 87.0.131.207/32 -j ACCEPT
#HTTPD
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
#SYSLOG
#-A INPUT -p udp -m udp --dport 514 -s 10.20.0.1/32 -j ACCEPT
#-A INPUT -p udp -m udp --dport 514 -s 10.20.0.2/32 -j ACCEPT
#NTP
#-A INPUT -p udp -m udp --dport 123 -s 10.20.0.1/32 -j ACCEPT
#-A INPUT -p udp -m udp --dport 123 -s 10.20.0.2/32 -j ACCEPT
-A INPUT -j undef_in
#OUTPUT
-A OUTPUT -o lo -j ACCEPT
-A OUTPUT -o enp0s3 -j ACCEPT
-A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j DROP
-A OUTPUT -j undef_out
# LAST RULES
-A undef_fw -j LOG --log-prefix "-- FW -- DROP " --log-level 6
-A undef_fw -j DROP
-A undef_in -j LOG --log-prefix "-- IN -- DROP " --log-level 6
-A undef_in -j DROP
-A undef_out -j LOG --log-prefix "-- OUT -- DROP " --log-level 6
-A undef_out -j DROP
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
```
