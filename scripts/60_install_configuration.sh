#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -b $1 ]; then
	echo -e "Usage:\n $0 <partition>\n\nexample:\n $0 /dev/sdc1\n\n"
	exit -1
fi

PARTITION=$1
ROOTFS_MOUNT=/media/rootfs

trap "sudo umount ${ROOTFS_MOUNT}; exit" INT TERM EXIT

sudo mount ${PARTITION} ${ROOTFS_MOUNT}

# create fstab
sudo sh -c "echo '/dev/mmcblk0p1        /       auto    errors=remount-ro       0       1' >> ${ROOTFS_MOUNT}/etc/fstab"
#sudo sh -c "echo 'UUID=77d0b11c-c5b7-41d6-98ad-1b6250c3345d       /home   ext4    errors=remount-ro       0       1' >> ${ROOTFS_MOUNT}/etc/fstab"

# setup network
sudo mkdir -p ${ROOTFS_MOUNT}/etc/network/interfaces.d
sudo cp -a tools/eth0.cfg ${ROOTFS_MOUNT}/etc/network/interfaces
