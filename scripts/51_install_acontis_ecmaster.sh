#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -d $1 ]; then
	echo -e "Usage:\n $0 <rootfs_mount>\n\nexample:\n $0 /tmp/rootfs\n\n"
	exit -1
fi

ROOTFS_MOUNT=$1

ACONTIS_ECMASTER=acontis/EC-Master
KERNEL=kernel

CROSS_PREFIX=arm-linux-gnueabihf-

KERNELDIR=`pwd`/${KERNEL}

if [ -d "${ACONTIS_ECMASTER}" ] ; then
pushd ${ACONTIS_ECMASTER}/Sources/LinkOsLayer/Linux/atemsys
make ARCH=arm KDIR=${KERNELDIR} KERNELDIR=${KERNELDIR} CROSS_COMPILE=${CROSS_PREFIX} INSTALL_MOD_PATH=${ROOTFS_MOUNT} modules_install
popd

printf "atemsys\n" > ${ROOTFS_MOUNT}/etc/modules-load.d/atemsys.conf

cp -ar ${ACONTIS_ECMASTER} ${ROOTFS_MOUNT}/opt/

# Create /usr/local/bin/RunEcMasterDemo.sh
printf "#!/bin/sh\n" > ${ROOTFS_MOUNT}/usr/local/bin/RunEcMasterDemo.sh
printf "cd /opt/EC-Master/Bin/Linux/armv6-vfp-eabihf\n" >> ${ROOTFS_MOUNT}/usr/local/bin/RunEcMasterDemo.sh
printf "./EcMasterDemo -ccat 1 1\n" >> ${ROOTFS_MOUNT}/usr/local/bin/RunEcMasterDemo.sh
chmod a+x ${ROOTFS_MOUNT}/usr/local/bin/RunEcMasterDemo.sh

fi
