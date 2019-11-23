#! /bin/bash

##########################
#     Setting up vars    #
##########################

#Rofi command:
dmenuc="rofi -dmenu -config $ROFIBARPATH"

#First prompt
cwalp="1) Change wallpaper"
ccols="2) Change system colors"
eloop="3) End wallpaper loop"
conflist="$cwalp
$ccols
$eloop"

#getPicsList prompts
donept="Done"
rempt="Remove files from list"
rrmpt="Chose which pics to remove"
vispt="Visually select"

#Loop prompts
sleeppt="Sleep time in seconds?"

#Changecolors prompt
ccpt="Change term colors?"

#Global vars
picslist=""
scandir="$HOME/Pictures/wallpapers/repo/"
awpf="$MEAD_PATH/.auxfiles/autowp"
pidf="$MEAD_PATH/customiz3d/.pidf"

#Defining vars for color changing
rofipath="$MEAD_PATH/.configs/rofi/MorktHrad.rasi"
rofipath2="$MEAD_PATH/.configs/rofi/bar.rasi"
i3path="$MEAD_PATH/.configs/i3/config"
dunstpath="$MEAD_PATH/.configs/dunst/dunstrc"
colf="$MEAD_PATH/.auxfiles/color_schemes"
colpt="Chose a color scheme"

#Defining functions
getPicsList(){
	local keepPicsLoop=1 #If set to 0, loop will end
	local option=""

	#Changes to directories and adds files to the picslist
	while [ $keepPicsLoop == 1 ]; do
		cd $scandir
		option=$(echo -e "../\n$(ls -1)\n\n$vispt\n$rempt\n$donept" | $dmenuc -p "Select files")
		[ "$option" == "$donept" ] && keepPicsLoop=0 					#If done, end loop
		[ "$option" == "$rempt" ] && removeFromPicsList					#Go to remove pic function
		[ "$option" == "$vispt" ] && picslist="$picslist $(ls $(pwd)/*.jpg $(pwd)/*.png | sxiv - -tfbo)" #Visually add pics via sxiv
		[ -f "$option" ] && picslist="$picslist $(pwd)/$option" 			#Add option to list
		[ -d "$option" ] && scandir="$option"						#cd to dir
	done
}

sxivRemovePics(){
	local remlist=$(cat $tmpfile | sxiv - -tfbo)
	for words in $remlist; do
		local aux=$(mktemp)
		cat $tmpfile | grep -v $words > $aux
		cat $aux > $tmpfile
		rm $aux
	done
}

removeFromPicsList(){
	local keepRemLoop=1 #If set to 0, loop will end
	local option=""
	tmpfile=$(mktemp)

	#Adding pics files to temp file
	for words in $picslist; do
		echo $words >> $tmpfile
	done

	#Getting file to remove from list
	while [ $keepRemLoop == 1 ]; do
		option="$(echo -e "$(cat $tmpfile)\n\n$vispt\n$donept" | $dmenuc -p "$rrmpt")"
		[ "$option" == "$donept" ] && keepRemLoop=0
		[ "$option" == "$vispt" ] && sxivRemovePics

		#Removing from list
		if [ -f "$option" ]; then
			local aux=$(mktemp)
			cat $tmpfile | grep -v $option > $aux
			cat $aux > $tmpfile
			rm $aux
		fi
	done

	picslist=$(cat $tmpfile)

	rm $tmpfile
}

wallpaperLoop(){
	local ccols=$(echo -e "Yes\nNo" | $dmenuc -p "$ccpt")
	local sleeptime=$($dmenuc -p "$sleeppt")

	[ ${#sleeptime} -lt 1 ] || [ $sleeptime -eq 0 ] && exit 0

	echo $BASHPID > $pidf
	while [ 1 ]; do
		for words in $picslist; do
			[ "$ccols" == "Yes" ] && echo "wal -i $words" > $awpf && sh $awpf
			[ "$ccols" == "No" ] && echo "feh --bg-fill $words" > $awpf && sh $awpf
			sleep $sleeptime
		done
	done
}

endLoop(){
	kill $(cat $pidf)
	echo "" > $pidf
}

changeWallpaper(){
	getPicsList

	#If more than one file, jump to loop function and quit
	picamm=$(echo $picslist | wc -w)
	[ $picamm -eq 0 ] && exit 0;
	[ $picamm -gt 1 ] && wallpaperLoop "$picslist" && exit 0

	local ccols=$(echo -e "Yes\nNo" | $dmenuc -p "$ccpt")
	[ "$ccols" == "Yes" ] && echo "wal -i $picslist" > $awpf && sh $awpf && exit 0
	[ "$ccols" == "No" ] && echo "feh --bg-fill $picslist" > $awpf && sh $awpf && exit 0
}

colorChange(){
	#Getting chosen color
	col=$(cat $colf | head -n -2 | $dmenuc -p "$colpt")
	[ ${#col} -lt 10 ] && exit 0

	#Setting vars for outputting to files
	bgc=$(awk '{print $2}' <<< "$col")
	brc=$(awk '{print $3}' <<< "$col")
	crt=$(awk '{print $4}' <<< "$col")

	changeI3Cols

	changeRofiCols

	changeDunstCols

	i3-msg restart > /dev/null
}

changeDunstCols(){
	local temp=$(mktemp)
	cat $dunstpath | head -n -19 > $temp
	printf '    separator = "' >> $temp ; printf $crt >> $temp ; echo '"' >> $temp
	echo "" >> $temp

	echo "[urgency_critical]" >> $temp
	echo  '    background = "#900000"' >> $temp
	echo '    foreground = "#ffffff"' >> $temp
	echo '    frame_color = "#ff0000"' >> $temp
	echo "    timeout = 0" >> $temp
	echo "" >> $temp

	echo "[urgency_low]" >> $temp
	printf '    background = "' >> $temp ; printf $bgc >> $temp ; echo '"' >> $temp
	printf '    foreground = "' >> $temp ; printf $crt >> $temp ; echo '"' >> $temp
	printf '    frame_color = "' >> $temp ; printf $crt >> $temp ; echo '"' >> $temp
	echo "    timeout = 5" >> $temp
	echo "" >> $temp

	echo "[urgency_normal]" >> $temp
	printf '    background = "' >> $temp ; printf $bgc >> $temp ; echo '"' >> $temp
	printf '    foreground = "' >> $temp ; printf $crt >> $temp ; echo '"' >> $temp
	printf '    frame_color = "' >> $temp ; printf $crt >> $temp ; echo '"' >> $temp
	echo "    timeout = 5" >> $temp
	mv $temp $dunstpath
}

changeRofiCols(){
	local temp1=$(mktemp)
	local temp2=$(mktemp)
	cat $rofipath | head -n -8 > $temp1
	cat $rofipath2 | head -n -8 > $temp2
	printf "    bgt: $bgc" >> $temp1 ; echo "bf;" >> $temp1
	printf "    brt: $brc" >> $temp1 ; echo "bf;" >> $temp1
	printf "    crt: $crt" >> $temp1 ; echo "bf;" >> $temp1
	printf "    bgo: $bgc" >> $temp1 ; echo "ff;" >> $temp1
	printf "    bro: $brc" >> $temp1 ; echo "ff;" >> $temp1
	printf "    cro: $crt" >> $temp1 ; echo "ff;" >> $temp1
	echo "    background-color: #00000000;" >> $temp1
	echo "    }" >> $temp1

	printf "    bgt: $bgc" >> $temp2 ; echo "bf;" >> $temp2
	printf "    brt: $brc" >> $temp2 ; echo "bf;" >> $temp2
	printf "    crt: $crt" >> $temp2 ; echo "bf;" >> $temp2
	printf "    bgo: $bgc" >> $temp2 ; echo "ff;" >> $temp2
	printf "    bro: $brc" >> $temp2 ; echo "ff;" >> $temp2
	printf "    cro: $crt" >> $temp2 ; echo "ff;" >> $temp2
	echo "    background-color: #00000000;" >> $temp2
	echo "    }" >> $temp2

	mv $temp1 $rofipath
	mv $temp2 $rofipath2
}

changeI3Cols(){
	local temp=$(mktemp)
	cat $i3path | head -n -3 > $temp
	echo "set \$bg-color $bgc" >> $temp
	echo "set \$bright-color $brc" >> $temp
	echo "set \$contrast-text $crt" >> $temp
	mv $temp $i3path
}

########
# MAIN #
########

conf=$(echo "$conflist" | $dmenuc -p "What to do?")

case $conf in
	"$cwalp") changeWallpaper ;;
	"$eloop") endLoop ;;
	"$ccols") colorChange ;;
esac
