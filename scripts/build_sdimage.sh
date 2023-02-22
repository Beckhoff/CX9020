#!/bin/bash

set -e
set -o nounset

function cleanup
{
	umount "${ROOTFS_MOUNT}" || true
	exit
}

IMAGE=sdcard.img
ROOTFS_MOUNT="$(mktemp -d)"
MBR=tools/mbr.bin
PARTITION_CONFIG=tools/partitions.sfdisk
SCRIPT_PATH="$(dirname "$0")"
SFDISK_OPTIONS="--force"
image_size_mb=400

trap cleanup INT TERM EXIT


dd if=/dev/zero of="${IMAGE}" bs=1M count="${image_size_mb}"
mkfs.ext4 -F -E offset=1048576 "${IMAGE}"
dd if=${MBR} of=${IMAGE} conv=notrunc
"${SCRIPT_PATH}/20_install_uboot.sh" "${IMAGE}"
sfdisk ${SFDISK_OPTIONS} ${IMAGE} < ${PARTITION_CONFIG}

mount "${IMAGE}" "${ROOTFS_MOUNT}" -o loop,offset=1048576
"${SCRIPT_PATH}/40_install_rootfs.sh" "${ROOTFS_MOUNT}"
if test -r "${SCRIPT_PATH}/../os-release"; then
	cat "${SCRIPT_PATH}/../os-release" >> "${ROOTFS_MOUNT}/etc/os-release"
fi
