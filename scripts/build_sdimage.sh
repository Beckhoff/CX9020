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
MBR=tools/mbr.bin
PARTITION_CONFIG=tools/partitions.sfdisk
SCRIPT_PATH="`dirname \"$0\"`"
SFDISK_OPTIONS="--force"
image_size_mb=238

trap cleanup INT TERM EXIT

rm -rf ${TMP_MOUNT}
mkdir -p ${TMP_MOUNT}
${SCRIPT_PATH}/40_install_rootfs.sh ${TMP_MOUNT}
if test -r "${SCRIPT_PATH}/../os-release"; then
	cat "${SCRIPT_PATH}/../os-release" >> "${TMP_MOUNT}/etc/os-release"
fi

dd if=/dev/zero of=${RAMDISK_IMAGE} bs=1M count=${image_size_mb}
mkfs.ext2 -F -E offset=1048576,root_owner=${ROOTFS_OWNER} ${RAMDISK_IMAGE}
dd if=${MBR} of=${RAMDISK_IMAGE} conv=notrunc
"${SCRIPT_PATH}/20_install_uboot.sh" "${RAMDISK_IMAGE}"
sfdisk ${SFDISK_OPTIONS} ${RAMDISK_IMAGE} < ${PARTITION_CONFIG}

mkdir -p ${ROOTFS_MOUNT}
mount ${RAMDISK_IMAGE} ${ROOTFS_MOUNT} -o loop,offset=1048576
mv ${TMP_MOUNT}/* ${ROOTFS_MOUNT}/
