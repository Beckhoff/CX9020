#!/bin/bash
# RT patches are hosted here: https://www.kernel.org/pub/linux/kernel/projects/rt/
# Overview of maintained kernels: https://kernel.org/releases.html

set -e
set -o nounset

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
git clone git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git ${REPO}
pushd ${REPO}
git checkout -b dev-${RT_VERSION} v${RT_VERSION}

# apply cx9020 patches
patch -p1 < ../kernel-patches/0001_fix_imx53_uart2_pinmux.patch
patch -p1 < ../kernel-patches/0002_ipu_diX_sel_can_set_parent_rates.patch
patch -p1 < ../kernel-patches/0003_add_mode_valid__and__add_ddc_support.patch
patch -p1 < ../kernel-patches/0005_add_multiplexed_read_status.patch
patch -p1 < ../kernel-patches/0006_add_imx53_cx9020_devicetree.patch

# apply prepared config
cp -a ../kernel-patches/config-CX9020 .config
