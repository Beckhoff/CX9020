#!/bin/bash

sed -i '\|optargs| s|$| init=/sbin/init-ro|' /boot/uEnv.txt
