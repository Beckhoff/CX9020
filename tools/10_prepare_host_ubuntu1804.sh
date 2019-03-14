#!/bin/sh

DEBIAN_FRONTEND='noninteractive'
sudo dpkg --add-architecture i386
printf "\ndeb http://ppa.launchpad.net/team-gcc-arm-embedded/ppa/ubuntu bionic main\n" | sudo tee -a /etc/apt/sources.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key B4D03348F75E3362B1E1C2A1D1FAA6ECF64D33B0
sudo apt-get update
sudo apt-get install --no-install-recommends -o Dpkg::Options::="--force-confold" -y \
	autoconf \
	automake \
	bc \
	binfmt-support \
	bison \
	device-tree-compiler \
	flex \
	gcc-arm-embedded \
	gcc-5-arm-linux-gnueabihf \
	g++-5-arm-linux-gnueabihf \
	git \
	gpg \
	lib32ncurses5-dev \
	lib32stdc++6 \
	lib32z1 \
	liblz4-tool \
	libsdl1.2-dev \
	libssl-dev \
	libtool \
	make \
	mercurial \
	multistrap \
	python-coverage \
	python-dev \
	python-pip \
	python-pytest \
	python-setuptools \
	qemu \
	qemu-user-static \
	swig \
	wget \
	xz-utils

sudo pip install \
	wheel
sudo pip install \
	coverage \
	pyfdt

# patch multistrap (https://github.com/volumio/Build/issues/348)
sed -i '/^$config_str .= " -o Apt::Get::AllowUnauthenticated=true"$/i  $config_str .= " -o Acquire::AllowInsecureRepositories=true";' /usr/sbin/multistrap

sudo ln -s /usr/bin/arm-linux-gnueabihf-gcc-5 /usr/bin/arm-linux-gnueabihf-gcc
sudo ln -s /usr/bin/arm-linux-gnueabihf-g++-5 /usr/bin/arm-linux-gnueabihf-g++
