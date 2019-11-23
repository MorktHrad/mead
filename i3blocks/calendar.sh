#! /bin/bash

case $BLOCK_BUTTON in
	1) notify-send -t 0 "$(cal --monday)" ;;
	2) notify-send -t 0 "$(cal --monday -3)" ;;
	3) notify-send -t 0 "$(cal --monday -y)" ;;
esac

case $1 in
	d) echo " $(date '+%a %d-%m')" ;;
	t) echo " $(date +%H:%M)" ;;
esac
