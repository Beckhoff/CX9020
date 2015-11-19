#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ]; then
	echo -e "Usage:\n $0 <u-boot version>\n\nexample:\n $0 v2015.07"
	exit 64
fi

VERSION=$1

git clone git://git.denx.de/u-boot.git
pushd u-boot/
git checkout ${VERSION} -b dev-${VERSION}
patch -p1 < ../u-boot-patches/0001_fix_iomux_for_uart2.patch
patch -p1 < ../u-boot-patches/0002_set_ufcr_dte_for_cx9020_uart.patch
patch -p1 < ../u-boot-patches/0003_add_beckhoff_cx9020.patch

git add *
git commit -m "apply cx9020 patches"
