#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -b $1 ]; then
	echo -e "Usage:\n $0 <partition>\n\nexample:\n $0 /dev/sdc1\n\n"
	exit -1
fi

PARTITION=$1
ROOTFS_MOUNT=/media/rootfs

ETHERLAB=ethercat-hg
KERNEL=kernel

CROSS_PATH=`pwd`/tools/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin
CROSS_PREFIX=`pwd`/tools/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-

trap "sudo umount ${ROOTFS_MOUNT}; exit" INT TERM EXIT

sudo mount ${PARTITION} ${ROOTFS_MOUNT}

pushd ${ETHERLAB}
sudo make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} INSTALL_MOD_PATH=${ROOTFS_MOUNT} modules_install
sudo make DESTDIR=${ROOTFS_MOUNT} install
popd

sudo mkdir -p ${ROOTFS_MOUNT}/etc/sysconfig/
sudo cp -a ${ROOTFS_MOUNT}/opt/etherlab/etc/sysconfig/ethercat ${ROOTFS_MOUNT}/etc/sysconfig/
sudo sed -b -i 's/MASTER0_DEVICE=\"\"/MASTER0_DEVICE=\"ff:ff:ff:ff:ff:ff\"/' ${ROOTFS_MOUNT}/etc/sysconfig/ethercat
sudo sed -b -i 's/DEVICE_MODULES=\"\"/DEVICE_MODULES=\"ccat\"/' ${ROOTFS_MOUNT}/etc/sysconfig/ethercat
sudo ln -fs /opt/etherlab/etc/init.d/ethercat ${ROOTFS_MOUNT}/etc/init.d/
