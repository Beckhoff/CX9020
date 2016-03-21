#!/bin/bash

set -e
set -o nounset

if [ $# -ne 2 ] || ! [ -b $1 ]; then
	echo -e "Usage:\n $0 <partition> <mount_point>\n\nexample:\n $0 /dev/sdc1 /tmp/rootfs\n\n"
	exit -1
fi

PARTITION=$1
DEB_RELEASE=jessie
ROOTFS_MOUNT=$2
SCRIPT_PATH="`dirname \"$0\"`"

sudo mkfs.ext4 ${PARTITION}

sudo mkdir -p ${ROOTFS_MOUNT}
sudo mount ${PARTITION} ${ROOTFS_MOUNT}

