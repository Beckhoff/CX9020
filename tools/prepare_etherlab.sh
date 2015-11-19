#!/bin/bash

# get the etherlab sources
hg clone http://hg.code.sf.net/p/etherlabmaster/code ethercat-hg

pushd ethercat-hg/
hg update stable-1.5
wget https://github.com/Beckhoff/CCAT/raw/master/etherlab.bundle
hg unbundle etherlab.bundle
hg update
./bootstrap
