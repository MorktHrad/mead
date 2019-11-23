#! /bin/bash

# CONFIGURATION:
brgpath="/sys/class/backlight/intel_backlight"
kbdpath="/sys/class/leds/asus::kbd_backlight"
backlightfile="brightness"
maxbacklight="max_brightness"
badusg="Bad usage\nUse the -h option for more information"

helpmenu="\n\tA simple backlight changing script.\n\n

	\tUsage:\n
	\t*.sh <operand/option> [value] [keyboard/monitor]\n\n

	\tExample:\n
	\t*.sh + 100 -> increases brightness by 100.\n\n

	\tOptions:\n
	\t-h, --help: Show this menu and exit.\n
	\t-s, --set: Sets brightness to literal value.\n
	\t-m, --max: Sets brightness to maximum value.\n
	\t-mv, --max_value: Shows maximum value.\n
	\t-cv, --current_value: Shows current value.\n
	\t-o, --off: Sets brightness to 0.\n
	\t-t, --toggle; toggles between max or min value.\n\n

	\t-M, --monitor: change monitor brightness.\n
	\t-K, --keyboard: change keyboard brightness.\n
"

# FUNCTIONS
getMaxBrightness(){
	cat $pathtobacklight/$maxbacklight
}

changeBrightness(){
	echo $1 > $pathtobacklight/$backlightfile
	pkill -SIGRTMIN+20 i3blocks
}

getCurrentBrightness(){
	cat $pathtobacklight/$backlightfile
}

getNewBrightnessValue(){
	mod=$1
	val=$2
	bgvalue=$(getCurrentBrightness)
	echo $(getGoodValue $(($bgvalue $mod $val)))
}

toggleBrightness(){
	current=$(getCurrentBrightness)
	if [ $current != 0 ]; then
		changeBrightness 0
	else
		max=$(getMaxBrightness)
		changeBrightness $max
	fi
}

getGoodValue(){
	maxbrightnessval=$(getMaxBrightness)
	if [ $1 -gt $maxbrightnessval ]; then
		goodvalue=$maxbrightnessval
	elif [ $1 -lt 0 ]; then
		goodvalue=0
	else
		goodvalue=$1
	fi
	echo $goodvalue

}

#MAIN SCRIPT

#Making monitor the default device
pathtobacklight="$brgpath"

#Selecting device
case $2 in
	-K | -k | --keyboard) pathtobacklight="$kbdpath";;
	-M | -m | --monitor) pathtobacklight="$brgpath";;
esac

case $3 in
	-K | -k | --keyboard) pathtobacklight="$kbdpath";;
	-M | -m | --monitor) pathtobacklight="$brgpath";;
esac



# DECLARING OPTIONS
[ $1 == "-h" ] || [ $1 == "--help" ] && echo -e $helpmenu && exit 0

case $1 in
	"-mv" 	| "--max-value") 	getMaxBrightness ;;
	"-cv"	| "--current-value")	getCurrentBrightness ;;
	"-m"	| "--max")		changeBrightness $(getMaxBrightness) ;;
	"-o"	| "--off")		changeBrightness 0 ;;
	"-t"	| "--toggle")		toggleBrightness ;;
	"-s"	| "--set")		changeBrightness $(getGoodValue $2) ;;
	*)				changeBrightness $(getNewBrightnessValue $1 $2) ;;
esac
