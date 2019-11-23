#! /bin/bash

#CONFIG
dmenuc="rofi -dmenu -config $ROFIBARPATH"

errorfile=$MEAD_PATH/.auxfiles/drivemounterstderr

#MAIN PROGRAM
case $1 in
	"-m")
		drive=$(lsblk -l | grep "t $" | awk '{print $1}'| $dmenuc -p "Drive to mount")
		[ ${#drive} -lt 2 ] && echo "No option" && exit
		folder="$(ls -1 /mnt | $dmenuc -p "Folder to mount drive (/mnt/...)")"
		[ ${#folder} -lt 2 ] && echo "No option" && exit
		sudo mount /dev/$drive /mnt/$folder > $errorfile 2>&1
		errormessage=$(cat $errorfile)
		if [ "$errormessage" == "" ]; then
			notify-send "Drive $drive mounted in $folder!"
		else
			notify-send "$errormessage"
		fi
		;;
	"-u")
		drive=$(lsblk -l | grep "t /" | awk '{print $1}' | grep -v "sdb1" | $dmenuc -p "Drive to unmount")
		[ ${#drive} -lt 2 ] && echo "No option" && exit
		mountpoint=$(lsblk -l | grep $drive | awk '{print $7}')
		sudo umount $mountpoint > $errorfile 2>&1
		errormessage=$(cat $errorfile)
		if [ "$errormessage" == "" ]; then
			notify-send "Drive $drive unmounted!"
		else
			notify-send "$errormessage"
		fi
		;;
	*)
		echo "
	Mounts / Unmounts drives.
		Usage:
		$0 -h: Shows this menu and exits
		$0 -m: Mounts drives
		$0 -u: Unmounts drives
		"
		;;
esac
