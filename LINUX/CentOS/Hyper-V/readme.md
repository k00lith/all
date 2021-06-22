Есть проблема когда CentOS живет в Hypeer-v или в других гипервизардах (можно погуглить по ключевым словам ниже)


Configuring the I/O scheduler on Red Hat Enterprise Linux 7
The default scheduler in later Red Hat Enterprise Linux 7 versions (7.5 and later) is deadline.
To make the changes persistent through boot you have to add elevator=noop toGRUB_CMDLINE_LINUX in /etc/default/grub as shown below.

```bash
# cat /etc/default/grub
[...]
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=vg00/lvroot rhgb quiet elevator=noop"
[...]
```

After the entry has been created/updated, rebuild the /boot/grub2/grub.cfg file to include the new configuration with the added parameter:

On BIOS-based machines: 
```bash
# grub2-mkconfig -o /boot/grub2/grub.cfg
```
On UEFI-based machines: 
```bash
# grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
```

Проверить:

```bash
cat /sys/block/sda/queue/scheduler
[noop] deadline cfq
```
