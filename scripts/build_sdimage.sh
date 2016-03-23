#!/bin/bash

set -e
set -o nounset

function cleanup
{
	umount ${ROOTFS_MOUNT} || true
	mv ${RAMDISK_IMAGE} ${IMAGE}
	exit
}

IMAGE=sdcard.img
RAMDISK=/dev/shm
RAMDISK_IMAGE=${RAMDISK}/${IMAGE}
ROOTFS_MOUNT=/tmp/rootfs
TMP_MOUNT=${ROOTFS_MOUNT}-tmp
ROOTFS_OWNER=${1-1001:1001}
UBOOT=u-boot/u-boot.imx
MBR=tools/mbr.bin
PARTITION_CONFIG=tools/partitions.sfdisk
SCRIPT_PATH="`dirname \"$0\"`"

trap cleanup INT TERM EXIT

rm -rf ${TMP_MOUNT}
mkdir -p ${TMP_MOUNT}
${SCRIPT_PATH}/40_install_rootfs.sh ${TMP_MOUNT}
${SCRIPT_PATH}/50_install_kernel.sh ${TMP_MOUNT}
${SCRIPT_PATH}/52_install_etherlab.sh ${TMP_MOUNT}
${SCRIPT_PATH}/60_install_configuration.sh ${TMP_MOUNT}

dd if=/dev/zero of=${RAMDISK_IMAGE} bs=1M count=238
mkfs.ext2 -F -E offset=1048576,root_owner=${ROOTFS_OWNER} ${RAMDISK_IMAGE}
dd if=${MBR} of=${RAMDISK_IMAGE} conv=notrunc
dd if=${UBOOT} of=${RAMDISK_IMAGE} seek=2 bs=512 conv=notrunc
sfdisk --force --in-order --Linux --unit M ${RAMDISK_IMAGE} < ${PARTITION_CONFIG}

mkdir -p ${ROOTFS_MOUNT}
mount ${ROOTFS_MOUNT}
mv ${TMP_MOUNT}/* ${ROOTFS_MOUNT}/
