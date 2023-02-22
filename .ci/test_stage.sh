#!/bin/bash
set -e
set -v
eval $(ssh-agent -s)
ssh-add <(echo "$SSH_PRIVATE_KEY")
mkdir -p ~/.ssh
[[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config

image="sdcard.img"
mount="$(mktemp -d)"

mount "${image}" "${mount}" -o loop,offset=1048576
mkdir -p "${mount}/root/.ssh"
ssh-add -L >> "${mount}/root/.ssh/authorized_keys"
chmod 600 "${mount}/root/.ssh/authorized_keys"
umount "${mount}"
rackctl-power test-device off

sdmux_id="$(rackctl-config get test-device sd-mux/id)"
_serial_console="/var/run/sd-mux/${sdmux_id}/aux-serial"
stty -F "${_serial_console}" 115200 cs8 -cstopb -parenb -echo > serial_output
tee -a serial_output < "${_serial_console}" &

rackctl-flash test-device ${image}
rackctl-dhcpd test-device &
rackctl-power test-device on
device_ip="$(rackctl-config get test-device ip)"
ssh_target="root@${device_ip}"
wait_ssh ${ssh_target}

if ! test -z ${CI_JOB_MANUAL-}; then
	.ci/run_tests.sh root "${device_ip}" || true
	sleep 1h
else
	.ci/run_tests.sh root "${device_ip}" &
	wait $!
fi
