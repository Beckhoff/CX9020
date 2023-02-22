#!/bin/sh
set -e

script_path="$(cd "$(dirname "$0")" && pwd)"
extra_dir="$0-files"
ssh_parameters="$1"
ssh_options="${ssh_parameters% *}"
ssh_remote="${ssh_parameters##* }"
ssh_cmd="ssh $ssh_options $ssh_remote"

${ssh_cmd} 'enable-rootfs-ro.sh'
${ssh_cmd} 'nohup reboot &>/dev/null & exit'
sleep 10
wait_ssh ${ssh_remote}
${ssh_cmd} 'mount' | grep mmc | grep "ro,"
${ssh_cmd} 'touch test'
