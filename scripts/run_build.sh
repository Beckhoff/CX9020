#!/bin/bash

set -e
set -o nounset

tools/prepare_uboot.sh v2018.11
make uboot-tests
make uboot
tools/prepare_kernel.sh v4.20
make kernel
tools/prepare_etherlab.sh
make etherlab
sudo scripts/build_sdimage.sh
