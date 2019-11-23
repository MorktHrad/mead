#! /bin/bash
CLASE="$($MEAD_PATH/assignments/assignments.sh -b)"

case $BLOCK_BUTTON in
	1) $MEAD_PATH/assignments/assignments.sh -s ;;
	3) $MEAD_PATH/assignments/assignments.sh -e ;;
esac

if ! [ ${#CLASE} -lt 3 ]; then
	printf "$CLASE  | \n"
fi
