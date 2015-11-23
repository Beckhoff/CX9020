#!/bin/bash
pushd tools
wget -c https://releases.linaro.org/14.09/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz
tar xfv gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz

# install libtool for cross compiling
wget http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
tar xfv libtool-2.4.6.tar.gz
cd libtool-2.4.6/
./configure --prefix=`pwd`/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux --host=arm-linux-gnueabihf --program-prefix=arm-linux-gnueabihf-
make
make install