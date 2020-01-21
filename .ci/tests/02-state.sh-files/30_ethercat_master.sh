#!/bin/sh
# SPDX-License-Identifier: MIT
# Copyright (C) 2020 Beckhoff Automation GmbH & Co. KG

set -e
set -u

readonly variant="${1##*:}"

test_acontis() {
	cd /opt/EC-Master/Bin/Linux/armv6-vfp-eabihf
	./EcMasterDemo -ccat 1 1 -t 10000 | grep "Bus scan successful - 5 slaves found"
}

test_etherlab() {
	timeout 10 /root/example.bin || true
	dmesg | grep "Domain 0: Working counter changed to 2/2"
}

test_${variant}
