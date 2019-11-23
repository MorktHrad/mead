#! /bin/bash

picsdir=$SCROTDIR

number=$(ls -1 $picsdir | wc -l)
number=$((number + 1))
case ${#number} in
	1) number="000$number" ;;
	2) number="00$number" ;;
	3) number="0$number" ;;
esac

date=$(date +%d-%m-%Y_at_%H-%M-%S)

filename="$number-Screenshot-$date"

scrot "$picsdir/$filename.png"

if [ "$1" == "-n" ]; then
	notify-send "$(echo -e "Took screenshot with name\n$filename.png")"
fi
