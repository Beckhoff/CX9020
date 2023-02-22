ACONTIS_ECMASTER=acontis/EC-Master
ETHERLAB=ethercat
KERNEL=kernel
UBOOT=u-boot
CCAT=ccat

CROSS_PREFIX=arm-none-eabi-
MAKE_JOBS=-j `nproc`

acontis: CROSS_PREFIX=arm-linux-gnueabihf-
acontis:
	cd ${ACONTIS_ECMASTER}/Sources/LinkOsLayer/Linux/atemsys && make MAKEFLAGS=ARCH=arm KDIR=$(CURDIR)/${KERNEL} KERNELDIR=$(CURDIR)/${KERNEL} CROSS_COMPILE=${CROSS_PREFIX} modules

etherlab: CROSS_PREFIX=arm-linux-gnueabihf-
etherlab:
	cd ${ETHERLAB} && ./configure --host=arm-linux-gnueabihf --with-linux-dir=`pwd`/../${KERNEL} --disable-generic --disable-8139too --disable-eoe --enable-ccat_netdev
	cd ${ETHERLAB} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} clean
	cd ${ETHERLAB} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS}
	cd ${ETHERLAB} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS} modules
	cd tests/etherlab && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS}

uboot-tests:
	cd ${UBOOT} && make tests

uboot:
	cd ${UBOOT} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} distclean
	cd ${UBOOT} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} mx53cx9020_defconfig
	cd ${UBOOT} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS}

kernel: CROSS_PREFIX=arm-linux-gnueabihf-
kernel:
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} oldconfig
#	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} menuconfig
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS}
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} ${MAKE_JOBS} modules
	cd ${KERNEL} && make ARCH=arm CROSS_COMPILE=${CROSS_PREFIX} imx53-cx9020.dtb
	cp -a ${KERNEL}/.config kernel-patches/config-CX9020
	cd ${CCAT} && make MAKEFLAGS=ARCH=arm KDIR=$(CURDIR)/$(KERNEL) CROSS_COMPILE=${CROSS_PREFIX}

.PHONY: busybox dropbear glibc kernel install uboot uboot-tests prepare_disk install_rootfs install_small install_smallrootfs post_install install_debian acontis etherlab
