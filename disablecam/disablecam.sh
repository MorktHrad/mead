#! /bin/bash

## CONFIG
my_path="$MEAD_PATH/.auxfiles"
statusfile="camerastatus"

## FUNCTIONS

disableWebCam(){
	if [ "$visualmode" == "y" ]; then
		rofi -dmenu -p "[Sudo] Password" -password | sudo -S rmmod uvcvideo && echo "off" > $my_path/$statusfile
	else
		sudo rmmod uvcvideo && echo "off" > $my_path/$statusfile
	fi

	pkill -SIGRTMIN+9 i3blocks
}

enableWebCam(){
	if [ "$visualmode" == "y" ]; then
		rofi -dmenu -p "[Sudo] Password" -password | sudo -S modprobe uvcvideo && echo "on" > $my_path/$statusfile
	else
		sudo modprobe uvcvideo  && echo "on" > $my_path/$statusfile
	fi

	pkill -SIGRTMIN+9 i3blocks
}

toggleWebCam(){
	local status=$(cat $my_path/$statusfile)
	case $status in
		"off") enableWebCam $visualmode ;;
		"on") disableWebCam $visualmode ;;
	esac
}

## MAIN

argument=$1
visualmode=$2

case $argument in
	-t) toggleWebCam ;;
	-d) disableWebCam ;;
	-e) enableWebCam ;;
esac
