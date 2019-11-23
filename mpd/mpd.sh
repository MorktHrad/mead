#! /bin/bash

mountpath="/mnt/SD/"
drive="mmcblk0p1"
devfolder="/dev"

case $1 in
	-v) verbose="y";;
esac

isMounted(){
	local s=$(lsblk -l | grep $drive | grep "t /")
	if [ ${#s} -gt 6 ]; then
		if [ "$(fixMountPoint)" == "fixed" ]; then
			echo "n"
		else
			echo "y"
		fi
	else
		echo "n"
	fi
}

fixMountPoint(){
	local s=$(lsblk -l | grep $drive | grep "t /mnt/SD$")
	if [ ${#s} -lt 6 ]; then
		sudo umount $devfolder/$drive
		echo "fixed"
	fi
}

ismpdRunning(){
	pid=$(pidof mpd)
	if [ ${#pid} -gt 2 ]; then
		echo "y"
	else
		echo "n"
	fi
}


[ "$verbose" == "y" ] && echo "Checking wether $drive is mounted on $mountpath"
if [ "$(isMounted)" == "n" ]; then
	[ "$verbose" == "y" ] && echo "It wasn't. Mounting..."
	sudo mount "$devfolder/$drive" "$mountpath"
else
	[ "$verbose" == "y" ] && echo "It was. Skipping mounting..."
fi

[ "$verbose" == "y" ] && echo "Checking wether mpd is running..."
if [ "$(ismpdRunning)" == "y" ]; then
	[ "$verbose" == "y" ] && echo "it was. Killing mpd..."
	kill $(pidof mpd)
else
	[ "$verbose" == "y" ] && echo "It wasn't. Skipping kill..."
fi

[ "$verbose" == "y" ] && echo "Starting mpd"
mpd
[ "$verbose" == "y" ] && echo "Running ncmpcpp"
ncmpcpp
