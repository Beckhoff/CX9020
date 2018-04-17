#!/bin/sh

DEBIAN_FRONTEND='noninteractive'
sudo dpkg --add-architecture i386
printf "\ndeb http://ppa.launchpad.net/team-gcc-arm-embedded/ppa/ubuntu xenial main\n" | sudo tee -a /etc/apt/sources.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key B4D03348F75E3362B1E1C2A1D1FAA6ECF64D33B0
sudo apt-get update
sudo apt-get install -o Dpkg::Options::="--force-confold" --force-yes -y \
	autoconf \
	bc \
	binfmt-support \
	device-tree-compiler \
	gcc-arm-embedded \
	gcc-5-arm-linux-gnueabihf \
	g++-5-arm-linux-gnueabihf \
	git \
	lib32ncurses5-dev \
	lib32stdc++6 \
	lib32z1 \
	libsdl1.2-dev \
	libssl-dev \
	libtool \
	make \
	mercurial \
	multistrap \
	python-pip \
	python-pytest \
	qemu \
	qemu-user-static \
	swig \
	wget \
	xz-utils

sudo pip install \
	coverage \
	pyfdt
