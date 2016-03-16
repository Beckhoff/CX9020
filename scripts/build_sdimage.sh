#!/bin/bash

set -e
set -o nounset

function cleanup
{
	sudo losetup -d ${PARTITION} || true
	sudo losetup -d ${DISK} || true
	mv ${RAMDISK}/${IMAGE} ${IMAGE}
	exit
}

DISK=/dev/loop0
PARTITION=/dev/loop1
IMAGE=sdcard.img
RAMDISK=/dev/shm
SCRIPT_PATH="`dirname \"$0\"`"

dd if=/dev/zero of=${RAMDISK}/${IMAGE} bs=1M count=488
sudo losetup ${DISK} ${RAMDISK}/${IMAGE}
sudo losetup ${PARTITION} ${DISK} -o $((2048 * 512))
trap cleanup INT TERM EXIT

${SCRIPT_PATH}/10_install_mbr.sh ${DISK}
${SCRIPT_PATH}/20_install_uboot.sh ${DISK}
${SCRIPT_PATH}/40_install_rootfs.sh ${PARTITION}
${SCRIPT_PATH}/50_install_kernel.sh ${PARTITION}
${SCRIPT_PATH}/52_install_etherlab.sh ${PARTITION}
${SCRIPT_PATH}/60_install_configuration.sh ${PARTITION}
