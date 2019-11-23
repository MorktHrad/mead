#! /bin/bash

device=$(xinput list | grep Touchpad | awk '{print $6}')
device=${device: -2}
state=$(xinput list-props $device | grep "Device Enabled" | grep -o "[01]$")
if [ $state == "1" ]; then
	xinput disable $device
	echo "0" > $MEAD_PATH/.auxfiles/tpstatus
	pkill -SIGRTMIN+19 i3blocks
else
	xinput enable $device
	echo "1" > $MEAD_PATH/.auxfiles/tpstatus
	pkill -SIGRTMIN+19 i3blocks
fi
