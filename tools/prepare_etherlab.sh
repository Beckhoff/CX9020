#!/bin/bash

# get the etherlab sources
hg clone http://hg.code.sf.net/p/etherlabmaster/code ethercat-hg

pushd ethercat-hg/
hg update stable-1.5
hg import ../ccat/etherlab-patches/000*
./bootstrap
