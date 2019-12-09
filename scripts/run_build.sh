#!/bin/bash
set -e

tools/prepare_uboot.sh v2019.10
make uboot
tools/prepare_kernel.sh v4.20
make kernel
tools/prepare_etherlab.sh
make etherlab
sudo http_proxy=${APT_CACHE_SERVER} scripts/build_sdimage.sh
