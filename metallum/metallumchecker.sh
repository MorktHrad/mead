#! /bin/bash
pathtoscript=$MEAD_PATH/metallum
idsfile=ids
htmlspath=htmls
diffsfile=diffs
i3blocksfile=$MEAD_PATH/i3blocks/metallum/.isrunning

getAlbumsLists(){
	max=$(cat $idsfile | wc -l)
	i=1
	templist=$(mktemp)
	echo "" >> $diffsfile
	echo "$(date '+%d-%m-%Y at %H:%M')" >> $diffsfile
	while read ID BANDNAME; do
		echo " $BANDNAME: $i/$max" > $i3blocksfile
		pkill -SIGRTMIN+8 i3blocks
		curl https://www.metal-archives.com/band/discography/id/$ID/tab/main | grep albums | awk '{print $2}' > "$templist"
		#notify-send "$i/$max: Curled $BANDNAME"
		i=$(($i + 1))
		if [ -f "$htmlspath/$BANDNAME" ]; then
			cmp --silent "$htmlspath/$BANDNAME" "$templist" || notifyFor $BANDNAME
		fi
		cat $templist > "$htmlspath/$BANDNAME"
	done < $pathtoscript/$idsfile
	rm $templist
	diffslen=$(cat $diffsfile)
	if [ "${#diffslen}" -gt 3 ]; then
		notify-send "$(cat $diffsfile)"
		echo -e " Bands updated!" > $i3blocksfile
	else
		echo "" > $i3blocksfile
	fi
	pkill -SIGRTMIN+8 i3blocks
}

notifyFor(){
	notify-send -t 0 "Difference in $BANDNAME"
	echo "$BANDNAME" >> $diffsfile
}

cd $pathtoscript
getAlbumsLists
