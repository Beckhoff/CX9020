#!/bin/bash
# RT patches are hosted here: https://www.kernel.org/pub/linux/kernel/projects/rt/
# Overview of maintained kernels: https://kernel.org/releases.html

set -e

if [ "$#" -ne 3 ]; then

        echo -e "Usage:\n $0 <VERSION> <PATCH> <RT-PATCH>\n\nexample: to checkout kernel 4.1.12 with rt13\n $0 4.1 12 13"
        exit 64
fi

VERSION=$1
PATCH=$2
FULL_VERSION=${VERSION}.${PATCH}
RT_VERSION=${FULL_VERSION}-rt${3}
REPO=kernel

# clone a clean linux-rt-devel repository
git clone git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git ${REPO} ${GIT_CLONE_ARGS}
pushd ${REPO}
git checkout -b dev-${RT_VERSION} v${RT_VERSION}

# apply cx9020 patches
git am < ../kernel-patches/0001-clk-imx5-ipu_di_sel-clocks-can-set-parent-rates.patch
git am < ../kernel-patches/0002-imx-parallel-display-add-ddc-support.patch
git am < ../kernel-patches/0003-ARM-dts-imx-add-CX9020-Embedded-PC-device-tree.patch

# apply prepared config
cp -a ../kernel-patches/config-CX9020 .config
