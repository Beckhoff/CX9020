#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -d $1 ]; then
	echo -e "Usage:\n $0 <rootfs_mount>\n\nexample:\n $0 /tmp/rootfs\n\n"
	exit -1
fi

ROOTFS_MOUNT=$1

ETHERLAB=ethercat-hg
KERNEL=kernel

CROSS_PATH=`pwd`/tools/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin
CROSS_PREFIX=`pwd`/tools/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-

pushd ${ETHERLAB}
sudo make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} INSTALL_MOD_PATH=${ROOTFS_MOUNT} modules_install
sudo make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} DESTDIR=${ROOTFS_MOUNT} PATH=${PATH}:${CROSS_PATH} install
popd

sudo mkdir -p ${ROOTFS_MOUNT}/etc/sysconfig/
sudo cp -a ${ROOTFS_MOUNT}/opt/etherlab/etc/sysconfig/ethercat ${ROOTFS_MOUNT}/etc/sysconfig/
sudo sed -b -i 's/MASTER0_DEVICE=\"\"/MASTER0_DEVICE=\"ff:ff:ff:ff:ff:ff\"/' ${ROOTFS_MOUNT}/etc/sysconfig/ethercat
sudo sed -b -i 's/DEVICE_MODULES=\"\"/DEVICE_MODULES=\"ccat\"/' ${ROOTFS_MOUNT}/etc/sysconfig/ethercat
sudo ln -fs /opt/etherlab/etc/init.d/ethercat ${ROOTFS_MOUNT}/etc/init.d/
