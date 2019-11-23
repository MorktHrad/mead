#! /bin/bash
tpstatus=$(cat $MEAD_PATH/.auxfiles/tpstatus)
if [ $tpstatus == "0" ]; then
	echo "   | "
fi
