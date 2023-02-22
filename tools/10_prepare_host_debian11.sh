#!/bin/sh

DEBIAN_FRONTEND='noninteractive'
sudo apt-get update
sudo apt-get install --no-install-recommends -o Dpkg::Options::="--force-confold" -y \
	autoconf \
	automake \
	bc \
	binfmt-support \
	bison \
	debootstrap \
	device-tree-compiler \
	fdisk \
	flex \
	g++-arm-linux-gnueabihf \
	gcc-arm-none-eabi \
	git \
	gpg \
	kmod \
	lib32ncurses-dev \
	lib32stdc++-10-dev\
	lib32z1 \
	liblz4-tool \
	libsdl1.2-dev \
	libssl-dev \
	libtool \
	make \
	patch \
	python3-coverage \
	python3-dev \
	python3-pip \
	python3-pytest \
	python3-setuptools \
	qemu \
	qemu-user-static \
	swig \
	wget \
	xz-utils

sudo pip3 install \
	wheel
sudo pip3 install \
	coverage \
	pyfdt
