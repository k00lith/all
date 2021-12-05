### Kerio Control 9.2.7 build 2921. ###

##### Наткнулся на баг:

На керио: обязательно одна подсеть должна быть на физическом интерфейсе (native vlan, та, что не будет тегироваться), 
остальные вланы и подсети для них вешаем на физ интерфейс как саб интерфейсы.
На свитче: есть дефолтный влан у которого нет метки - он так и называется default , все порты по умолчанию в нем. 
Настраиваем порт, который смотрит на керио в транк режиме и указываем native vlan default. 
Остальные порты везде где будет присутствовать влан для воипа (транк - если к телефону будет подключен телефон, аксесс - если телефон это оконечка на порту), 
нужно указывать native vlan default. Если такие настройки не делать , то разрешенный трафик между вланами ходить не будет.

---

##### Баг:

> the way I found this works correctly is if you set the static ip address on your firewalls physical interface and use that as your default gateway for your primary native vlan default gateway.
> for example set kerio physical port 1 to 172.16.0.1 (this is will act as the untagged vlan ip) and set it to be assigned (tagged) to vlan 10 and vlan 20.
> the switch ports should be untagged for vlan 1 and tagged for vlan 10 and vlan 20. clients on vlan 10 need to use the vlan10 virtual interface ip as their default gateway 192.168.10.1.
> this only works if the the vlan1 (default or native vlan) ip is configured on the physical port of kerio which is being used as the trunk to a switch.
> also make sure you have traffic rules allowing dns, dhcp or "all" traffic to&from the virtual vlan interfaces to&from the firewall. example rule is source:vlan10&vlan20&firewall<--->destination:vlan10&vlan20&firewall, allowed, all.
