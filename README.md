# prepare your machine f.e.: 64-bit Ubuntu 14.04 LTS would require:
===================================================================
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y debootstrap qemu binfmt-support qemu-user-static mercurial libtool autoconf lib32z1 lib32ncurses5-dev lib32stdc++6 git


#get the repository:
#===================
git clone https://github.com/Beckhoff/CX9020.git
cd CX9020/

#get and install a cross compiler:
#=================================
./tools/install_linaro_gcc.sh

#get and patch the u-boot sources:
#=================================
./tools/prepare_uboot.sh v2015.07

#build u-boot:
#=============
make uboot

#get and patch a rt kernel:
#==========================
./tools/prepare_kernel.sh 4.1 12 13

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
./scripts/install.sh /dev/sdc

#install etherlab (optional):
=============================
./scripts/52_install_etherlab.sh /dev/sdc1
