#!/bin/sh
set -e

script_path="$(cd "$(dirname "$0")" && pwd)"
extra_dir="$0-files"
extra_dir_basename="$(basename ${extra_dir})"
ssh_parameters="$1"
ssh_options="${ssh_parameters% *}"
ssh_remote="${ssh_parameters##* }"
ssh_cmd="ssh $ssh_options $ssh_remote"

scp -r $ssh_options ${extra_dir} $ssh_remote:~/
${ssh_cmd} "${extra_dir_basename}/is_system-running.sh"
${ssh_cmd} "${extra_dir_basename}/30_ethercat_master.sh \"${CI_JOB_NAME}\""
