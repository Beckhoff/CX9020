#!/bin/bash

sed -i '\|APPEND| s|$| init=/sbin/init-ro|' /boot/extlinux.conf.after
