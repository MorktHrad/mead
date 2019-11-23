#! /bin/bash

wifiinterface=$(ip a | grep 3: | grep -v link | awk '{print $2}')
wifiinterface=${wifiinterface:: -1}

case $BLOCK_BUTTON in
	1) notf=$(echo -e "Local  IP:\n$(ip a | grep $wifiinterface | grep inet | grep dynamic | awk '{print $2}')") ; notf2=$(echo -e "Public IP:\n$(wget -qO - icanhazip.com)") ; notify-send -t 0 "$notf"; notify-send -t 0 "$notf2" ;;
	# 3) quiet=$(bash $MEAD_PATH/nmcli/nmcli.sh -b) ;;
esac

currSSID=$(iwconfig $wifiinterface | grep ESSID | awk '{print $4}')
if [ "$currSSID" == "ESSID:off/any" ]; then
	echo " "
else
	signal=$(iwconfig $wifiinterface | grep Signal | awk '{print $2}')
	signal=${signal: 8}
	signal=${signal::-3}
	signal=$((signal*100/70))
	currSSID=${currSSID#*'"'}; echo "  $signal% ${currSSID%'"'*}"

fi
