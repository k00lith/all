### SOURCE + DESTINATION NAT BUG

Наткнулся на следующее:

Схема:
За SRX240 стоит Freepbx15 (Asterisk16)

SRX240:
SRX240B2 Version 12.1X46-D82 by builder on 2019-01-0

### БАГ:
При приземлении транка от ISP VOIP на FreePBX через Static NAT - голос корректно ходит
При приземлении транка от ISP VOIP на FreePBX через Destination NAT + Source NAT - односторонняя слышимость, слышно только человека, который в офисе за SRX, независимо от направления звонка

Снимали дамп Wireshark'ом, голос (оба) есть на внешнем интерфейсе, на внутреннем только внутренний голос :) - (политики и фиревол - были открыты)

Схема через Destination NAT + Source NAT иделально работает на SRX100B  Version 12.1X46-D86 by builder on 2019-04-0






