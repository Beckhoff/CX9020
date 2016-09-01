#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ] || ! [ -b $1 ]; then
	echo -e "Usage:\n $0 <disk>\n\nexample:\n $0 /dev/sdc\n\n"
	exit -1
fi

DISK=$1
UBOOT=u-boot

sudo dd if=${UBOOT}/u-boot.imx of=${DISK} seek=2 bs=512 conv=notrunc
sync
