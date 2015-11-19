#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -b $1 ]; then
	echo -e "Usage:\n $0 <partition>\n\nexample:\n $0 /dev/sdc1\n\n"
	exit -1
fi

PARTITION=$1
ROOTFS_MOUNT=/media/rootfs

KERNEL=kernel
kernel_version=`cat ${KERNEL}/include/config/kernel.release`
CCAT_FIRMWARE=tools/ccat.rbf

CC=`pwd`/tools/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-

trap "sudo umount ${ROOTFS_MOUNT}; exit" INT TERM EXIT

sudo mount ${PARTITION} ${ROOTFS_MOUNT}

# install kernel
pushd ${KERNEL}
sudo make ARCH=arm CROSS_COMPILE=${CC} INSTALL_MOD_PATH=${ROOTFS_MOUNT} modules_install
popd
mkdir -p ${ROOTFS_MOUNT}/boot
sudo cp -v ${KERNEL}/arch/arm/boot/zImage ${ROOTFS_MOUNT}/boot/vmlinuz-${kernel_version}
sudo sh -c "echo 'uname_r=${kernel_version}' > ${ROOTFS_MOUNT}/boot/uEnv.txt"
sudo sh -c "echo 'optargs=libphy.num_phys=2 console=tty0 quiet' >> ${ROOTFS_MOUNT}/boot/uEnv.txt"

# install device tree binary
sudo mkdir -p ${ROOTFS_MOUNT}/boot/dtbs/${kernel_version}/
sudo cp -a ${KERNEL}/arch/arm/boot/dts/imx53-cx9020.dtb ${ROOTFS_MOUNT}/boot/dtbs/${kernel_version}/
sudo sh -c "echo 'dtb=imx53-cx9020.dtb' >> ${ROOTFS_MOUNT}/boot/uEnv.txt"

# install ccat firmware
sudo cp -v ${CCAT_FIRMWARE} ${ROOTFS_MOUNT}/boot/ccat.rbf
sudo sh -c "echo 'ccat=/boot/ccat.rbf' >> ${ROOTFS_MOUNT}/boot/uEnv.txt"

echo "DONE: $0!"
