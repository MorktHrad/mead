#! /bin/bash

case $BLOCK_BUTTON in
	1) notify-send -t 0 "$(lsblk)" ;;
	2) $TERMINAL -e ranger & disown ;;
	3) notify-send -t 0 "$(df -h)" ;;
esac

line=$(df -h / | tail -1)
size=$(echo $line | awk '{print $2}')
used=$(echo $line | awk '{print $3}')
avai=$(echo $line | awk '{print $4}')
perc=$(echo $line | awk '{print $5}')

echo " ${used::-1} / $size ($perc)"
