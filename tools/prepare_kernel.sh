#!/bin/bash
# RT patches are hosted here: https://www.kernel.org/pub/linux/kernel/projects/rt/
# Overview of maintained kernels: https://kernel.org/releases.html

set -e

if [ "$#" -ne 1 ]; then

        echo -e "Usage:\n $0 <KERNEL_VERSION>\n\nexample:\n $0 v4.4.53-rt66"
        exit 64
fi

RT_VERSION=${1}
REPO=kernel
GIT_REMOTE=git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git
#GIT_REMOTE=git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git

ccat_remote="${ccat_remote:-https://github.com/Beckhoff/CCAT}"
ccat_branch="${ccat_branch:-master}"

# clone a clean linux-rt-devel repository
git clone ${GIT_REMOTE} ${REPO} ${GIT_CLONE_ARGS} ${KERNEL_CLONE_ARGS}
pushd ${REPO}
git checkout ${RT_VERSION} -b dev-${RT_VERSION}

# apply cx9020 patches
git am -3  ../kernel-patches/000*

# apply prepared config
cp -a ../kernel-patches/config-CX9020 .config

# clone ccat driver repository
popd
git clone -b ${ccat_branch} ${ccat_remote} ccat
