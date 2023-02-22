#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -d $1 ]; then
	echo -e "Usage:\n $0 <rootfs_mount>\n\nexample:\n $0 /tmp/rootfs\n\n"
	exit -1
fi

ROOTFS_MOUNT=$1

KERNEL=kernel
kernel_version=`cat ${KERNEL}/include/config/kernel.release`
ccat_modules=ccat/*ko
CCAT_FIRMWARE=tools/ccat.rbf
UBOOT_SCRIPT=tools/boot.scr
UBOOT_SCRIPT_TXT=tools/boot.txt

CROSS_PREFIX=arm-linux-gnueabihf-

install_dir="${ROOTFS_MOUNT}/lib/modules/${kernel_version}/"

# install kernel
pushd ${KERNEL}
rm -rf ${ROOTFS_MOUNT}/lib/modules/${kernel_version}/
make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} INSTALL_MOD_PATH=${ROOTFS_MOUNT} modules_install
popd
mkdir -p ${ROOTFS_MOUNT}/boot
cp -v ${KERNEL}/arch/arm/boot/zImage ${ROOTFS_MOUNT}/boot/vmlinuz-${kernel_version}

# install device tree binary
mkdir -p ${ROOTFS_MOUNT}/boot/dtbs/${kernel_version}/
cp -a ${KERNEL}/arch/arm/boot/dts/imx53-cx9020.dtb ${ROOTFS_MOUNT}/boot/dtbs/${kernel_version}/

# install ccat driver
mkdir -p ${install_dir}/extra/
cp ${ccat_modules} ${install_dir}/extra/

# install ccat firmware
cp -v ${CCAT_FIRMWARE} ${ROOTFS_MOUNT}/boot/ccat.rbf

# install u-boot configuration
cp "${UBOOT_SCRIPT}" "${ROOTFS_MOUNT}/boot/boot.scr"
cp "${UBOOT_SCRIPT_TXT}" "${ROOTFS_MOUNT}/boot/boot.txt"
cat > "${ROOTFS_MOUNT}/boot/extlinux.conf.after" <<EOF
TIMEOUT 20
PROMPT 1
DEFAULT linux

LABEL linux
MENU LABEL Debian Linux
KERNEL /boot/vmlinuz-${kernel_version}
DEVICETREEDIR /boot/dtbs/${kernel_version}
APPEND libphy.num_phys=2 console=tty0 quiet root=/dev/mmcblk0p1
EOF

echo "DONE: $0!"
