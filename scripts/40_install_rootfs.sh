#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -d $1 ]; then
	echo -e "Usage:\n $0 <rootfs_mount>\n\nexample:\n $0 /tmp/rootfs\n\n"
	exit -1
fi

ROOTFS_MOUNT=$1
SCRIPT_PATH="`dirname \"$0\"`"

#debian rootfs
echo "Building debian rootfs..."

debootstrap --arch=armhf --variant=minbase --include=\
ifupdown,\
isc-dhcp-client,\
kmod,\
libstdc++6,\
net-tools,\
netbase,\
openssh-server,\
systemd-sysv,\
vim-tiny\
	bullseye ${ROOTFS_MOUNT}

cp /usr/bin/qemu-arm-static ${ROOTFS_MOUNT}/usr/bin/
cp /etc/resolv.conf ${ROOTFS_MOUNT}/etc/
cp ${SCRIPT_PATH}/install_rootfs_second_stage.sh ${ROOTFS_MOUNT}
chmod u+x ${ROOTFS_MOUNT}/install_rootfs_second_stage.sh
sudo chroot ${ROOTFS_MOUNT} /bin/bash -c "./install_rootfs_second_stage.sh"

${SCRIPT_PATH}/50_install_kernel.sh ${ROOTFS_MOUNT}
${SCRIPT_PATH}/51_install_acontis_ecmaster.sh ${ROOTFS_MOUNT}
${SCRIPT_PATH}/52_install_etherlab.sh ${ROOTFS_MOUNT}
${SCRIPT_PATH}/60_install_configuration.sh ${ROOTFS_MOUNT}

# install read only init script
cp ${SCRIPT_PATH}/../tools/init-ro ${ROOTFS_MOUNT}/sbin/
cp ${SCRIPT_PATH}/../tools/enable-rootfs-ro.sh ${ROOTFS_MOUNT}/usr/bin/

# remove chroot helpers
rm ${ROOTFS_MOUNT}/install_rootfs_second_stage.sh
rm ${ROOTFS_MOUNT}/etc/resolv.conf
rm ${ROOTFS_MOUNT}/usr/bin/qemu-arm-static

echo "DONE: Building debian rootfs!"
