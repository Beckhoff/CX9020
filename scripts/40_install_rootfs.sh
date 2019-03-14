#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -d $1 ]; then
	echo -e "Usage:\n $0 <rootfs_mount>\n\nexample:\n $0 /tmp/rootfs\n\n"
	exit -1
fi

ROOTFS_MOUNT=$1
SCRIPT_PATH="`dirname \"$0\"`"

trap "sudo umount -f ${ROOTFS_MOUNT}/dev || true; exit" INT TERM EXIT

#debian rootfs
echo "Building debian rootfs..."

multistrap -f ${SCRIPT_PATH}/../tools/multistrap.conf -d ${ROOTFS_MOUNT}

cp /usr/bin/qemu-arm-static ${ROOTFS_MOUNT}/usr/bin/
cp /etc/resolv.conf ${ROOTFS_MOUNT}/etc/
cp ${SCRIPT_PATH}/install_rootfs_second_stage.sh ${ROOTFS_MOUNT}
chmod u+x ${ROOTFS_MOUNT}/install_rootfs_second_stage.sh
/bin/mknod -m 0666 ${ROOTFS_MOUNT}/dev/null c 1 3
/bin/mknod -m 0666 ${ROOTFS_MOUNT}/dev/random c 1 8
/bin/mknod -m 0444 ${ROOTFS_MOUNT}/dev/urandom c 1 9
sudo chroot ${ROOTFS_MOUNT} /bin/bash -c "./install_rootfs_second_stage.sh"

${SCRIPT_PATH}/50_install_kernel.sh ${ROOTFS_MOUNT}
${SCRIPT_PATH}/52_install_etherlab.sh ${ROOTFS_MOUNT}
${SCRIPT_PATH}/60_install_configuration.sh ${ROOTFS_MOUNT}

# remove chroot helpers
rm ${ROOTFS_MOUNT}/install_rootfs_second_stage.sh
rm ${ROOTFS_MOUNT}/etc/resolv.conf
rm ${ROOTFS_MOUNT}/usr/bin/qemu-arm-static

echo "DONE: Building debian rootfs!"
