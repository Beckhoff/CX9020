#!/bin/bash

LINARO=gcc-linaro-5.3.1-2016.05-x86_64_arm-linux-gnueabihf
pushd tools
wget -c https://releases.linaro.org/components/toolchain/binaries/5.3-2016.05/arm-linux-gnueabihf/${LINARO}.tar.xz
tar xf ${LINARO}.tar.xz

# install libtool for cross compiling
wget http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
tar xfv libtool-2.4.6.tar.gz
cd libtool-2.4.6/
./configure --prefix=`pwd`/${LINARO} --host=arm-linux-gnueabihf --program-prefix=arm-linux-gnueabihf-
make
make install
