# CX9020

This repository provides Scripts and Patches to build a basic Linux (Debian) System for a [Beckhoff CX9020 Controller](https://www.beckhoff.com/default.asp?embedded_pc/cx9020.htm).
It only works with devices which are ordered with a special ordering number (CX9020-0100) which ensures that the device boots directly from the microSD card instead of using the internal bootloader.
Please make sure to follow the steps below to create your microSD card.

## Installation
```
#prepare your machine f.e.: 64-bit Ubuntu 16.04 LTS would require:
#=================================================================
./tools/10_prepare_host_ubuntu1604.sh

# get the repository:
#====================
git clone https://github.com/Beckhoff/CX9020.git
cd CX9020/

# link gcc-5-arm as default arm compiler
#=======================================
sudo ln -s /usr/bin/arm-linux-gnueabihf-gcc-5 /usr/bin/arm-linux-gnueabihf-gcc
sudo ln -s /usr/bin/arm-linux-gnueabihf-g++-5 /usr/bin/arm-linux-gnueabihf-g++

#get and patch the u-boot sources:
#=================================
./tools/prepare_uboot.sh v2018.07-rc1

#build u-boot:
#=============
make uboot

#get and patch a rt kernel:
#==========================
./tools/prepare_kernel.sh v4.17

#configure and build the kernel:
#===============================
make kernel

#get and patch etherlab (optional):
#==================================
./tools/prepare_etherlab.sh

#configure and build the etherlab (optional):
#============================================
make etherlab

#prepare sdcard with a small debian rootfs:
#============================================
#BE CAREFUL to specify the correct device name,
#or you might end up deleting your host's root partition!
./scripts/install.sh /dev/sdc /tmp/rootfs

#install etherlab (optional):
#=============================
./scripts/52_install_etherlab.sh /tmp/rootfs
```
## Usage
The standard login on first boot:

User:     root

Password: root

Please change the root password immediately and additionally create your own user.

## History
**TODO:** Write history
