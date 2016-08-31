#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -b $1 ]; then
	echo -e "Usage:\n $0 <disk>\n\nexample:\n $0 /dev/sdc\n\n"
	exit -1
fi

DISK=$1
MBR=tools/mbr.bin
PARTITION_CONFIG=tools/partitions.sfdisk
SFDISK_VERSION=$(LC_ALL=C sfdisk -v | awk '{ print $4 }')

if [[ ${SFDISK_VERSION} < "2.26.1" ]]; then
	SFDISK_OPTIONS="--force --in-order --Linux --unit M"
else
	SFDISK_OPTIONS="--force"
fi

sudo umount ${DISK}* || /bin/true

# clear bootsector and partition table
#sudo dd if=/dev/zero of=${DISK} bs=512 count=2
sudo dd if=${MBR} of=${DISK}
sync

# create partition for rootfs
sudo sfdisk ${SFDISK_OPTIONS} ${DISK} < ${PARTITION_CONFIG}
sudo partprobe ${DISK}
