#!/bin/sh
set -e

ssh_cmd="ssh $1"

${ssh_cmd} 'uname -a'
