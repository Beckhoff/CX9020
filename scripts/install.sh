#!/bin/bash

set -e
set -o nounset

if [ "$1" = '--skip-partitioning' ]; then
	shift
	partition=no
else
	partition=yes
fi

if [ $# -ne 2 ]; then
	echo -e "Usage:\n $0 [--skip-partitioning] <disk> <mountpoint>\n\nexample:\n $0 /dev/sdc /tmp/rootfs\n\n"
	exit -1
fi

DISK=$1
PARTITION=${DISK}1
ROOTFS_MOUNT=$2
SCRIPT_PATH="`dirname \"$0\"`"

[ "$partition" = 'yes' ] && ${SCRIPT_PATH}/10_install_mbr.sh ${DISK}
${SCRIPT_PATH}/20_install_uboot.sh ${DISK}
${SCRIPT_PATH}/30_install_partition.sh ${PARTITION} ${ROOTFS_MOUNT}
${SCRIPT_PATH}/40_install_rootfs.sh ${ROOTFS_MOUNT}
sudo umount ${ROOTFS_MOUNT}
