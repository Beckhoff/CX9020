#!/bin/bash
# for background see: https://bugs.launchpad.net/ubuntu/+source/multistrap/+bug/1313787
sed -i 's/$forceyes //g' /usr/sbin/multistrap
