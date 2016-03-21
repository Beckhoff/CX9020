#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -d $1 ]; then
	echo -e "Usage:\n $0 <rootfs_mount>\n\nexample:\n $0 /tmp/rootfs\n\n"
	exit -1
fi

ROOTFS_MOUNT=$1
SCRIPT_PATH="`dirname \"$0\"`"

trap "sudo umount -f ${ROOTFS_MOUNT}/dev || true; exit" INT TERM EXIT

#debian rootfs
echo "Building debian rootfs..."

sudo multistrap -f ${SCRIPT_PATH}/../tools/multistrap.conf -d ${ROOTFS_MOUNT}

sudo cp /usr/bin/qemu-arm-static ${ROOTFS_MOUNT}/usr/bin/
sudo cp /etc/resolv.conf ${ROOTFS_MOUNT}/etc/
sudo cp ${SCRIPT_PATH}/install_rootfs_second_stage.sh ${ROOTFS_MOUNT}
sudo chmod u+x ${ROOTFS_MOUNT}/install_rootfs_second_stage.sh
sudo mount --bind /dev ${ROOTFS_MOUNT}/dev
sudo chroot ${ROOTFS_MOUNT} /bin/bash -c "./install_rootfs_second_stage.sh"

# remove chroot helpers
sudo umount ${ROOTFS_MOUNT}/dev
sudo rm ${ROOTFS_MOUNT}/install_rootfs_second_stage.sh
sudo rm ${ROOTFS_MOUNT}/etc/resolv.conf
sudo rm ${ROOTFS_MOUNT}/usr/bin/qemu-arm-static

echo "DONE: Building debian rootfs!"
