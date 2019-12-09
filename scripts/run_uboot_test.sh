#!/bin/bash
set -e

tools/prepare_uboot.sh v2019.10
make uboot-tests
