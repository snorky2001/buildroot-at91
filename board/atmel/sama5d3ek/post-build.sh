#!/bin/bash

dd if=/dev/zero of=${1}/root/backing_file bs=1M count=16
mkfs.vfat ${1}/root/backing_file

mkdir ${1}/etc/profile.d
rm ${1}/etc/profile.d/usb.sh 2> /dev/null
echo "#!/bin/sh" > ${1}/etc/profile.d/usb.sh
echo "echo \"2 4 1 7\" > /proc/sys/kernel/printk" >> ${1}/etc/profile.d/usb.sh
echo "modprobe ehci-hcd" >> ${1}/etc/profile.d/usb.sh
echo "modprobe ohci-hcd" >> ${1}/etc/profile.d/usb.sh
echo "modprobe usb-storage" >> ${1}/etc/profile.d/usb.sh
echo "modprobe ehset" >> ${1}/etc/profile.d/usb.sh
echo "modprobe g_mass_storage file=/root/backing_file" >> ${1}/etc/profile.d/usb.sh
echo "export USBVIEW_LOG_LVL=3" >> ${1}/etc/profile.d/usb.sh

echo "debugfs              /sys/kernel/debug    debugfs    defaults              0  0" >> ${1}/etc/fstab

echo "SUBSYSTEM==\"usb\", ENV{DEVTYPE}==\"usb_device\", RUN+=\"/usr/bin/usbviewc\"" > ${1}/etc/udev/rules.d/50-usb-device.rules
