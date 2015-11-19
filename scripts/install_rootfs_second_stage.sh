#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ]; then
	echo -e "Usage:\n $0 <debian release>\n\nexample:\n $0 jessie\n\n"
	exit -1
fi

DEB_RELEASE=$1

/debootstrap/debootstrap --second-stage

echo -e "deb http://ftp.de.debian.org/debian ${DEB_RELEASE} main contrib non-free\ndeb-src http://ftp.de.debian.org/debian ${DEB_RELEASE} main contrib non-free\ndeb http://ftp.de.debian.org/debian ${DEB_RELEASE}-updates main contrib non-free\ndeb-src http://ftp.de.debian.org/debian ${DEB_RELEASE}-updates main contrib non-free\ndeb http://security.debian.org/debian-security ${DEB_RELEASE}/updates main contrib non-free\ndeb-src http://security.debian.org/debian-security ${DEB_RELEASE}/updates main contrib non-free\n" > /etc/apt/sources.list

apt-get clean
rm -rf /var/lib/apt/lists/*

echo 'root:root' | chpasswd
echo 'CX9020' > /etc/hostname
exit
