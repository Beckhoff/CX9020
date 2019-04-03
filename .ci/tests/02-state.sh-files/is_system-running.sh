#!/bin/sh
set -e

system_state="$(systemctl is-system-running || true)"
while [ "$system_state" = "starting" ]
do 
	system_state="$(systemctl is-system-running || true)"
	echo "waiting for system to finish starting"
	sleep 1
done

ret=0
systemctl is-system-running || ret=$?

systemctl list-units --state=failed
exit $ret
