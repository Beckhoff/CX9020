#!/bin/bash

set -e
set -o nounset

function cleanup
{
	sudo umount -f ${TMP_MOUNT} || true
	sudo umount -d ${ROOTFS_MOUNT} || true
	sudo losetup -d ${DISK}
	exit
}

DISK=/dev/loop0
PARTITION=/dev/loop1
IMAGE=sdcard.img
ROOTFS_MOUNT=/media/rootfs
TMP_MOUNT=/tmp/old
SCRIPT_PATH="`dirname \"$0\"`"


mv ${IMAGE} ${IMAGE}-old

trap cleanup INT TERM EXIT

dd if=/dev/zero of=${IMAGE} bs=1M count=239
sudo losetup ${DISK} ${IMAGE}
sudo losetup ${PARTITION} ${DISK} -o $((2048 * 512))
${SCRIPT_PATH}/10_install_mbr.sh ${DISK}
${SCRIPT_PATH}/20_install_uboot.sh ${DISK}

sudo mkfs.ext2 ${PARTITION}
sudo mkdir -p ${ROOTFS_MOUNT}
sudo mount ${PARTITION} ${ROOTFS_MOUNT}

sudo mkdir -p ${TMP_MOUNT}
sudo mount -t ext2 -o loop,offset=$((2048 * 512)) ${IMAGE}-old ${TMP_MOUNT}

sudo cp -a ${TMP_MOUNT}/* ${ROOTFS_MOUNT}/
