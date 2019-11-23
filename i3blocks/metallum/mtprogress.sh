#! /bin/bash

scriptloc=$MEAD_PATH/i3blocks/metallum

cd $scriptloc

case $BLOCK_BUTTON in
	1) echo "" > .isrunning; notify-send -t 0 "$(cat $HOME/bashcripts/metallum/diffs)" ;;
esac

if [ "$(cat .isrunning)" != "" ]; then
	echo "$(cat .isrunning) |"
fi
