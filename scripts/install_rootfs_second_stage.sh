#!/bin/bash
# run this inside of your chroot'ed new rootfs

set -e

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C LANGUAGE=C LANG=C

/var/lib/dpkg/info/dash.preinst install
cp -a /usr/share/zoneinfo/Europe/Berlin /etc/localtime

dpkg --configure -a

echo 'root:root' | chpasswd
echo 'CX9020' > /etc/hostname
