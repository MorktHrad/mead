#! /bin/bash
case $BLOCK_BUTTON in
	1) $MEAD_PATH/powerm/powerm.sh ;;
	2) $MEAD_PATH/powerm/powerm.sh -l ;;
	3) i3-msg -q bar mode toggle ;;
esac
