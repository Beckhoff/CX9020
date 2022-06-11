# CX9020

This repository provides Scripts and Patches to build a basic Linux (Debian) System for a [Beckhoff CX9020 Controller](https://www.beckhoff.com/default.asp?embedded_pc/cx9020.htm).
It only works with devices which are ordered with a special ordering number (CX9020-0100) which ensures that the device boots directly from the microSD card instead of using the internal bootloader.
Please make sure to follow the steps below to create your microSD card.

## Installation
```
# Get the repository
#====================
git clone https://github.com/Beckhoff/CX9020.git
cd CX9020
```

If you have a supported distro, just call the appropriate script and prepare your system.
```
# Prepare your machine, e.g. 64-bit Ubuntu 18.04 LTS would require
#=================================================================
./tools/10_prepare_host_ubuntu1804.sh

# Get and patch the u-boot sources
#=================================
tools/prepare_uboot.sh v2019.10

# Get and patch a rt kernel
#==========================
tools/prepare_kernel.sh v4.19-rt

```

Otherwise you can leverage docker (assuming you have it already installed). In this case you need to have the SD card you want to write to already connected to the host system and parititioned, so it can be exposed to the container.
```
# Create an Ubuntu 18.04 LTS image ready for building
#====================================================
docker build -t cx9020 -f Dockerfile.builder .

# Partition the destination SD card
#==================================
scripts/10_install_mbr.sh <SDCARD DEVICE>

# Start the container
#====================
docker run -itw /root/CX9020/ --privileged --device=<SDCARD DEVICE>:<SDCARD DEVICE> cx9020 /bin/bash
```

In both cases, after preparing, follow the instructions below to build everything.
```
# Build u-boot
#=============
make uboot

# Configure and build the kernel
#===============================
make kernel

# Integrate acontis kernel extension atemsys from EC-Master SDK for emllCCAT support (optional)
#==============================================================================================
tools/prepare_acontis.sh
make acontis

# Build the etherlab master stack (optional)
#===========================================
tools/prepare_etherlab.sh
make etherlab

# Prepare the SD card: pass --skip-partitioning if using docker
#==============================================================
scripts/install.sh --skip-partitioning <SDCARD DEVICE> /tmp/rootfs
```

## Usage

The standard login on first boot:

User:     root
Password: root

Please change the root password immediately and additionally create your own user.

You can also access with SSH by using the following user:

User:     cx9020
Password: cx9020

### acontis EC-Master example (optional)

To run the EcMasterDemo, extract the EC-Master SDK in /opt/EC-Master and start it from /opt/EC-Master/Bin/Linux/armv6-vfp-eabihf using:
```
EcMasterDemo -ccat 1 1
```
See manuals in the SDK's "Doc" folder for how to build and run EC-Master applications

## History

**TODO:** Write history
