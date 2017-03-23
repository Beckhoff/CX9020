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

CROSS_PREFIX=arm-linux-gnueabihf-

pushd ${ETHERLAB}
make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} INSTALL_MOD_PATH=${ROOTFS_MOUNT} modules_install
# This workaround is required to cross compile ethercat userspace tool for CX9020(armhf)
# see https://github.com/sittner/ec-debianize/issues/2
touch ./master/soe_errors.c
make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} DESTDIR=${ROOTFS_MOUNT} install
popd

mkdir -p ${ROOTFS_MOUNT}/etc/sysconfig/
cp -a ${ROOTFS_MOUNT}/opt/etherlab/etc/sysconfig/ethercat ${ROOTFS_MOUNT}/etc/sysconfig/
sed -b -i 's/MASTER0_DEVICE=\"\"/MASTER0_DEVICE=\"ff:ff:ff:ff:ff:ff\"/' ${ROOTFS_MOUNT}/etc/sysconfig/ethercat
sed -b -i 's/DEVICE_MODULES=\"\"/DEVICE_MODULES=\"ccat\"/' ${ROOTFS_MOUNT}/etc/sysconfig/ethercat
ln -fs /opt/etherlab/etc/init.d/ethercat ${ROOTFS_MOUNT}/etc/init.d/
