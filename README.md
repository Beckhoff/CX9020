# CX9020

This repository provides Scripts and Patches to build a basic Linux (Debian) System for a [Beckhoff CX9020 Controller](https://www.beckhoff.com/default.asp?embedded_pc/cx9020.htm).
It only works with devices which are ordered with a special ordering number (CX9020-0100) which ensures that the device boots directly from the microSD card instead of using the internal bootloader.
Please make sure to follow the steps below to create your microSD card.

## Installation
```
#prepare your machine f.e.: 64-bit Ubuntu 18.04 LTS would require:
#=================================================================
./tools/10_prepare_host_ubuntu1804.sh

# get the repository:
#====================
git clone https://github.com/Beckhoff/CX9020.git
cd CX9020/

#get and patch the u-boot sources:
#=================================
./tools/prepare_uboot.sh v2019.10

#build u-boot:
#=============
make uboot

#get and patch a rt kernel:
#==========================
./tools/prepare_kernel.sh v4.19-rt

#configure and build the kernel:
#===============================
make kernel

#integrate acontis kernel extension atemsys from EC-Master SDK for emllCCAT support (optional):
#==============================================================================================
export ACONTIS_EC_MASTER_SDK_PACKAGE=$PWD/EC-Master-V3.0-Linux_armv6-vfp-eabihf-Eval.tar.gz
wget -O $ACONTIS_EC_MASTER_SDK_PACKAGE http://software.acontis.com/EC-Master/3.0/EC-Master-V3.0-Linux_armv6-vfp-eabihf-Eval.tar.gz
./tools/prepare_acontis_ecmaster.sh
make acontis-atemsys

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
```
## Usage
The standard login on first boot:

User:     root

Password: root

Please change the root password immediately and additionally create your own user.

### acontis EC-Master example (optional)
To run the EcMasterDemo, extract the EC-Master SDK in /opt/EC-Master and start it from /opt/EC-Master/Bin/Linux/armv6-vfp-eabihf using:
```
EcMasterDemo -ccat 1 1
```
See manuals in the SDK's "Doc" folder for how to build and run EC-Master applications

## History
**TODO:** Write history
