#!/bin/bash
set -e

tools/prepare_uboot.sh v2018.11
make uboot-tests
