#!/bin/bash
set -e
set -v
eval $(ssh-agent -s)
ssh-add <(echo "$SSH_PRIVATE_KEY")
mkdir -p ~/.ssh
[[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
40_flash_sd.sh sdcard.img
50_power.sh ${DEVICE_ID}-${DEVICE} 1
51_wait.sh ${DEVICE_ID}-${DEVICE} root

if ! test -z ${CI_JOB_MANUAL-}; then
	.ci/run_tests.sh root "${TEST_DEVICE_IP}" || true
	sleep 1h
else
	.ci/run_tests.sh root "${TEST_DEVICE_IP}" &
	wait $!
fi
