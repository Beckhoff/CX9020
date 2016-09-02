#!/bin/bash

set -e
set -o nounset

if [ $# -ne 1 ]; then
	echo -e "Usage:\n $0 <u-boot version>\n\nexample:\n $0 v2016.07"
	exit 64
fi

VERSION=$1

git clone git://git.denx.de/u-boot.git ${GIT_CLONE_ARGS}
pushd u-boot/
git checkout ${VERSION} -b dev-${VERSION}
git am -3 < ../u-boot-patches/0001-serial-mxc-add-support-for-UFCR_DTE.patch
git am -3 < ../u-boot-patches/0002-board-mx53cx9020-add-support-for-Beckhoff-CX9020-010.patch
