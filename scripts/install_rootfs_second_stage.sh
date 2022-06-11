#!/bin/bash
# run this inside of your chroot'ed new rootfs

set -e

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C LANGUAGE=C LANG=C

/var/lib/dpkg/info/dash.preinst install
cp -a /usr/share/zoneinfo/Europe/Berlin /etc/localtime

dpkg --configure -a

# Create `cx9020` user, so you can SSH into this box with it
useradd -ms /bin/bash cx9020

echo 'root:root' | chpasswd
echo 'cx9020:cx9020' | chpasswd

echo 'CX9020' > /etc/hostname
