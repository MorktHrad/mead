#! /bin/bash

toggleVolume(){
	volume=$(pamixer --get-volume)
	if [ $volume -gt 0 ]; then
		pamixer --set-volume 0
	else
		pamixer --set-volume 100
	fi
}

case $BLOCK_BUTTON in
	1) pamixer -t ;;
	2) ;;
	3) toggleVolume ;;
	4) pamixer -i 5 ;;
	5) pamixer -d 5 ;;
esac
volume=$(pamixer --get-volume)
volstatus=$(pamixer --get-mute)
if [ $volstatus == "true" ]; then
	volume=" $volume%"
else
	if [ $volume -eq 0 ]; then
		volume="   $volume%"
	elif [ $volume -lt 50 ]; then
		volume="  $volume%"
	else
		volume=" $volume%"
	fi
fi
echo "$volume"
