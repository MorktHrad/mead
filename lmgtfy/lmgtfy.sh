#! /bin/bash

starturl="https://lmgtfy.com/?q="
midurl=""
endurl="&iie=1"

query=$(echo "" | rofi -dmenu -p "Google query")
fwd=1
for words in $query; do
	if [ $fwd == 1 ]; then
		midurl="$midurl$(printf $words)"
		fwd=0
	else
		midurl="$midurl+$(printf $words)"
	fi
done
printf "$starturl$midurl$endurl" | xclip
