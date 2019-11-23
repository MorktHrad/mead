#! /bin/bash

case $BLOCK_BUTTON in
	1) $MEAD_PATH/disablecam/disablecam.sh -t y ;;
esac

## CONFIG
my_path="$MEAD_PATH/.auxfiles"
statusfile="camerastatus"

case "$(cat $my_path/$statusfile)" in
	"off") echo "    |" ;;
	"on") ;;
esac

