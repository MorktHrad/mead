#! /bin/bash

case $BLOCK_BUTTON in
	1) bash $MEAD_PATH/brightness/chbrightness.sh -t -M;;
	4) bash $MEAD_PATH/brightness/chbrightness.sh + 92 -M;;
	5) bash $MEAD_PATH/brightness/chbrightness.sh - 92 -M;;
esac

#Brightness files location and names
blfolder="/sys/class/backlight/intel_backlight"
blc="brightness"
blm="max_brightness"

#They hold info about screen's brightness
bmax=$(cat $blfolder/$blm)
blevel=$(cat $blfolder/$blc)

#It usually is based on a large arbitrary number, so we need to tweak the numbers
#A little so that the numbers step propperly
 if [ "$blevel" == "$bmax" ]; then
 	blevel=100
 else
 	blevel=$(($blevel *100 / $bmax))
 	lastdigit=${blevel: -1}
 	case $lastdigit in
 		1) blevel=$(($blevel -1 )) ;;
 		2) blevel=$(($blevel -2 ));;
 		3) blevel=$(($blevel +2 ));;
 		4) blevel=$(($blevel +1 ));;
 		5) ;;
 		6) blevel=$(($blevel -1 ));;
 		7) blevel=$(($blevel -2 ));;
 		8) blevel=$(($blevel +2 ));;
 		9) blevel=$(($blevel +1 ));;
 		0) ;;
 	esac
 fi

echo " $blevel%"
