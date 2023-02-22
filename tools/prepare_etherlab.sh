#!/bin/bash

# get the etherlab sources
git clone https://gitlab.com/etherlab.org/ethercat.git
pushd ethercat
git checkout stable-1.5
for i in ../ccat/etherlab-patches/*
    do patch --batch --strip=1 < "$i"
done
./bootstrap
