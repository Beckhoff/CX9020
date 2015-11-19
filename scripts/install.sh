#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ]; then
	echo -e "Usage:\n $0 <disk>\n\nexample:\n $0 /dev/sdc\n\n"
	exit -1
fi

DISK=$1
SCRIPT_PATH="`dirname \"$0\"`"

${SCRIPT_PATH}/10_install_mbr.sh ${DISK}
${SCRIPT_PATH}/20_install_uboot.sh ${DISK}
${SCRIPT_PATH}/40_install_rootfs.sh ${DISK}1
${SCRIPT_PATH}/50_install_kernel.sh ${DISK}1
#${SCRIPT_PATH}/52_install_etherlab.sh ${DISK}1
${SCRIPT_PATH}/60_install_configuration.sh ${DISK}1
