#!/bin/bash

set -e

if [ $# -ne 1 ]; then
	echo -e "Usage:\n $0 <u-boot version>\n\nexample:\n $0 v2018.11"
	exit 64
fi

VERSION=$1

git clone http://git.denx.de/u-boot.git ${GIT_CLONE_ARGS} ${UBOOT_CLONE_ARGS}
pushd u-boot/
git checkout ${VERSION} -b dev-${VERSION}
#git am -3 ../u-boot-patches/000*
