Trigger name:
```
TRAFFIC on Upload is OVER 80 Mbps on {HOST.NAME} L2-CHANNEL

```
Expression:

```
{device_name:ifOutOctets.[GigabitEthernet0/0/24].last()}>80000000

```

-----------------------------
Trigger name:

```
TRAFFIC on Download is OVER 90 Mbps on {HOST.NAME} L2-CHANNEL

```
Expression:

```
{device_name:ifInOctets.[GigabitEthernet0/0/24].last()}>90000000

```
