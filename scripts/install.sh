#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ]; then
	echo -e "Usage:\n $0 <disk>\n\nexample:\n $0 /dev/sdc\n\n"
	exit -1
fi

DISK=$1
PARTITION=${DISK}1
ROOTFS_MOUNT=/media/rootfs
SCRIPT_PATH="`dirname \"$0\"`"

${SCRIPT_PATH}/10_install_mbr.sh ${DISK}
${SCRIPT_PATH}/20_install_uboot.sh ${DISK}
${SCRIPT_PATH}/30_install_partition.sh ${PARTITION} ${ROOTFS_MOUNT}
${SCRIPT_PATH}/40_install_rootfs.sh ${ROOTFS_MOUNT}
${SCRIPT_PATH}/50_install_kernel.sh ${ROOTFS_MOUNT}
${SCRIPT_PATH}/52_install_etherlab.sh ${ROOTFS_MOUNT}
${SCRIPT_PATH}/60_install_configuration.sh ${ROOTFS_MOUNT}
sudo umount ${ROOTFS_MOUNT}
