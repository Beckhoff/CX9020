#!/bin/sh
# SPDX-License-Identifier: MIT
# Copyright (C) 2020 Beckhoff Automation GmbH & Co. KG

set -e
set -u

readonly script_path="$(cd "$(dirname "$0")" && pwd)"
readonly archive=EC-Master-V3.0-Linux_armv6-vfp-eabihf-Eval.tar.gz
readonly acontis=acontis/EC-Master

if ! sha512sum -c "${script_path}/${archive}.sha512"; then
	wget http://software.acontis.com/EC-Master/3.0/${archive}
fi

mkdir -p "${acontis}"
tar -C "${acontis}" -xf "${archive}"
