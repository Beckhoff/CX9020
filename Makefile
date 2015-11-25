ETHERLAB=ethercat-hg
KERNEL=kernel
UBOOT=u-boot

CROSS_PATH=$(shell pwd)/tools/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin
CROSS_PREFIX=$(shell pwd)/tools/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-

etherlab:
	cd ${ETHERLAB} && ./configure --host=arm-linux-gnueabihf --with-linux-dir=`pwd`/../${KERNEL} --disable-generic --disable-8139too --disable-eoe --disable-tool --enable-ccat PATH=${CROSS_PATH}:${PATH}
	cd ${ETHERLAB} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} clean
	cd ${ETHERLAB} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} PATH=${CROSS_PATH}:${PATH}
	cd ${ETHERLAB} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} modules

uboot:
	cd ${UBOOT} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} distclean
	cd ${UBOOT} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} mx53cx9020_defconfig
	cd ${UBOOT} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX}

kernel:
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} oldconfig
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} menuconfig
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX}
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} modules
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} imx53-cx9020.dtb
	cp -a ${KERNEL}/.config kernel-patches/config-CX9020

.PHONY: busybox dropbear glibc kernel install uboot prepare_disk install_rootfs install_small install_smallrootfs post_install install_debian
