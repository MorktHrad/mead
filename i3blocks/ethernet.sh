#! /bin/bash

ethinterface=$(ip a | grep 2: | grep -v link | awk '{print $2}')
ethinterface=${ethinterface:: -1}

case $BLOCK_BUTTON in
	1) notf=$(echo -e "Local  IP:\n$(ip a | grep $ethinterface | grep inet | grep dynamic | awk '{print $2}')") ; notf2=$(echo -e "Public IP:\n$(wget -qO - icanhazip.com)") ; notify-send -t 0 "$notf"; notify-send -t 0 "$notf2" ;;
esac

[ $(cat /sys/class/net/$ethinterface/operstate) == "up" ] && echo "" ; echo ""
