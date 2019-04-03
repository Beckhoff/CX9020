#!/bin/sh
set -e

if [ $# -ne 2 ]; then
	echo -e "\nUsage: $0 <ssh_user> <device_ip>\nf.e.: $0 "Administrator" "172.17.66.143"\n"
	exit 1
fi

script_path="$(cd "$(dirname "$0")" && pwd)"
user=$1
device=$2
ssh_options="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${user}@${device}"

# run tests on device
run-parts --regex '.*' --verbose --arg="${ssh_options}" ${script_path}/tests
