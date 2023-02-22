#!/bin/bash
# run this inside of your chroot'ed new rootfs

set -e

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C LANGUAGE=C LANG=C

cp -a /usr/share/zoneinfo/Europe/Berlin /etc/localtime

echo 'root:root' | /usr/sbin/chpasswd
echo 'CX9020' > /etc/hostname
