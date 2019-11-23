#! /bin/bash

#CONFIG
dmenuc="rofi -dmenu -config $ROFIBARPATH -p PowerMenu"
options="Lock Screen\nEject Disk\nExit to tty\nPower Off\nReboot\nUpdate Albums"
updatealbums="$MEAD_PATH/metallum/metallumchecker.sh"
ejectcmd="eject /dev/sr0"
ICON=$MEAD_PATH/.auxfiles/lockicon.png

lockScreen(){
	#Wait for rofi to fade out
	sleep 0.2

	#Setting up scrot path and taking screenshot
	SCROTBG=/tmp/screen.png

	scrot $SCROTBG

	# # Blur screenshot
	# convert $SCROTBG -blur 0x10 $SCROTBG

	#Full effect oneliner
	convert $SCROTBG -blur 0x10 $ICON -gravity center -composite $SCROTBG

	#Locking screen
	i3lock -f -e -i $SCROTBG

	#Removing screenshot file after unlock
	rm $SCROTBG

}

powerOff(){
	[ "$(echo -e "Power Off\nPower Offn't" | $dmenuc)" == "Power Off" ] && poweroff
}

rebootFunc(){
	[ "$(echo -e "Reboot\nRebootn't" | $dmenuc)" == "Reboot" ] && reboot
}

exitToTTY(){
	[ "$(echo -e "Go back to tty\nStay in i3" | $dmenuc)" == "Go back to tty" ] && i3-msg exit
}

# MAIN PROGRAM

if [ ${#1} -lt 2 ]; then
	arg=$(echo -e $options | $dmenuc)
	case $arg in
		"Lock Screen")		arg="-l" ;;
		"Eject Disk")		arg="-j" ;;
		"Exit to tty")		arg="-e" ;;
		"Power Off")		arg="-p" ;;
		"Reboot")		arg="-r" ;;
		"Update Albums")	arg="-m" ;;
	esac
else
	arg=$1
fi

case $arg in
	-l) lockScreen ;;
	-p) powerOff ;;
	-r) rebootFunc ;;
	-e) exitToTTY ;;
	-j) $ejectcmd ;;
	-m) $updatealbums ;;
esac
