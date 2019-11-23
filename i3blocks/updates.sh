#! /bin/bash

notify-updates(){
	tmpfile=$(mktemp)
	local pacupd=$(checkupdates)
	local aurupd=$(yay -Qum)
	if [ ${#pacupd} -gt 0 ]; then
		echo -e "Pacman:\n$pacupd" > $tmpfile
	fi
	if [ ${#aurupd} -gt 0 ]; then
		[ $(cat $tmpfile | wc -l) -gt 0 ] && echo "" >> $tmpfile
		echo -e "AUR:\n$aurupd" >> $tmpfile
	fi
	notify-send -t 0 "$(cat $tmpfile | awk '{print $1}')"
	rm $tmpfile
}

case $BLOCK_BUTTON in
	1) notify-send "Fetching updates..." && notify-updates ;;
	2) i3-msg exec bash $MEAD_PATH/efloat/efloat.sh "$TERMINAL -e yay -Sua" > /dev/null && pkill -SIGRTMIN+7 i3blocks;;
	3) i3-msg exec bash $MEAD_PATH/efloat/efloat.sh "$TERMINAL -e sudo pacman -Syu" > /dev/null && pkill -SIGRTMIN+7 i3blocks;;
esac

pacupdates=$(checkupdates | wc -l)
aurupdates=$(yay -Qum | wc -l)
if [ $pacupdates -gt 0 ] || [ $aurupdates -gt 0 ]; then
	echo "$pacupdates    $aurupdates  |"
fi
