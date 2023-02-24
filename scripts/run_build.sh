#!/bin/sh
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 - 2020 Beckhoff Automation GmbH & Co. KG

set -e
set -u

readonly variant="${CI_JOB_NAME##*:}"

tools/prepare_uboot.sh v2022.10
make uboot
tools/prepare_kernel.sh v4.19-rt
make kernel
tools/prepare_${variant}.sh
make ${variant}
sudo scripts/build_sdimage.sh
