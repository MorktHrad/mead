#! /bin/bash

echo "" > $HOME/bashcripts/horario/final.txt

while read LINE; do
	LINEA=""
	for words in $LINE; do
		if [ ${words::1} != '(' ]; then
			LINEA="$LINEA$words "
		fi
	done
	echo $LINEA >> $HOME/bashcripts/horario/final.txt

done < $HOME/bashcripts/horario/horario.txt

cat $HOME/bashcripts/horario/final.txt
