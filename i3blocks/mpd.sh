#! /bin/bash

case $BLOCK_BUTTON in
	1) mpc -q -p 6601 toggle  ;;
	2) song=$(mpc -p 6601 current) ; tmpfile=$(mktemp) ; cat "$HOME/.lyrics/$song.txt" > $tmpfile ; notify-send -t 0 "$(cat $tmpfile)";;
	3) notify-send -t 0 "$(mpc -q -p 6601 playlist)" ;;
	4) mpc -q -p 6601 volume +5 ;;
	5) mpc -q -p 6601 volume -5 ;;
esac

songstatus=$(mpc -p 6601 | head -2 | tail -1)
cropstatus=${songstatus::3}
cropl='[pl'
cropa='[pa'

playing='false'
case $cropstatus in
	$cropl) symbol="" ; playing='true' ;;
	# $cropa) symbol="" ; playing='true' ;;
	$cropa) symbol="" ; playing='true' ;;
esac

if [ "$playing" == "true" ]; then
	song=$(mpc -p 6601 current)
	mpdvolume=$(mpc -p 6601 volume)
	if [ "$mpdvolume" == "volume:100%" ]; then
	mpdvolume="100%"
	else
	mpdvolume=$(echo $mpdvolume | awk '{print $2}')
	fi
	echo "$symbol $song ($mpdvolume)"
fi
pkill -SIGRTMIN+3 i3blocks
