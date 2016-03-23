#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -d $1 ]; then
	echo -e "Usage:\n $0 <rootfs_mount>\n\nexample:\n $0 /tmp/rootfs\n\n"
	exit -1
fi

ROOTFS_MOUNT=$1

# create fstab
sh -c "echo '/dev/mmcblk0p1        /       auto    errors=remount-ro       0       1' >> ${ROOTFS_MOUNT}/etc/fstab"
#sudo sh -c "echo 'UUID=77d0b11c-c5b7-41d6-98ad-1b6250c3345d       /home   ext4    errors=remount-ro       0       1' >> ${ROOTFS_MOUNT}/etc/fstab"

# setup network
#mkdir -p ${ROOTFS_MOUNT}/etc/network/interfaces.d
#cp -a tools/eth0.cfg ${ROOTFS_MOUNT}/etc/network/interfaces.d/
cp -a tools/eth0.cfg ${ROOTFS_MOUNT}/etc/network/interfaces
