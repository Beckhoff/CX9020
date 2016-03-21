#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -b $1 ]; then
	echo -e "Usage:\n $0 <partition>\n\nexample:\n $0 /dev/sdc1\n\n"
	exit -1
fi

PARTITION=$1
DEB_RELEASE=jessie
ROOTFS_MOUNT=/media/rootfs
SCRIPT_PATH="`dirname \"$0\"`"

CC=`pwd`/tools/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-

trap "sudo umount -f ${ROOTFS_MOUNT}/dev | true; sudo umount ${ROOTFS_MOUNT}; exit" INT TERM EXIT

sudo umount ${PARTITION} || /bin/true
sudo mkfs.ext4 ${PARTITION}

sudo mkdir -p ${ROOTFS_MOUNT}
sudo mount ${PARTITION} ${ROOTFS_MOUNT}

#debian rootfs
echo "Building debian rootfs..."

sudo multistrap -f ${SCRIPT_PATH}/../tools/multistrap.conf -d ${ROOTFS_MOUNT}

sudo cp /usr/bin/qemu-arm-static ${ROOTFS_MOUNT}/usr/bin/
sudo cp /etc/resolv.conf ${ROOTFS_MOUNT}/etc/
sudo cp ${SCRIPT_PATH}/install_rootfs_second_stage.sh ${ROOTFS_MOUNT}
sudo chmod u+x ${ROOTFS_MOUNT}/install_rootfs_second_stage.sh
sudo mount --bind /dev ${ROOTFS_MOUNT}/dev
sudo chroot ${ROOTFS_MOUNT} /bin/bash -c "./install_rootfs_second_stage.sh ${DEB_RELEASE}"

# remove chroot helpers
sudo umount ${ROOTFS_MOUNT}/dev
sudo rm ${ROOTFS_MOUNT}/install_rootfs_second_stage.sh
sudo rm ${ROOTFS_MOUNT}/etc/resolv.conf
sudo rm ${ROOTFS_MOUNT}/usr/bin/qemu-arm-static

echo "DONE: Building debian rootfs!"
