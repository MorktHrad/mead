#! /bin/bash

case $BLOCK_BUTTON in
	1) notify-send -t 0 "$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)" ;;
esac

batwarningf=$MEAD_PATH/.auxfiles/batwarning

batlevel=$(cat $batwarningf)

BAT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | tr -d '%')
BATC=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}')

case $BATC in
	"discharging") 		BATC="" ;;
	"charging")		BATC="" ;;
	"fully-charged")	BATC="" ;;
esac

case 1 in
	$(( $BAT >= 90 ))) echo "healthy"  > $batwarningf ; BATS="" ;;
	$(( $BAT >= 70 ))) echo "healthy"  > $batwarningf ; BATS="" ;;
	$(( $BAT >= 40 ))) echo "healthy"  > $batwarningf ; BATS="" ;;
	$(( $BAT >= 15 ))) echo "healthy"  > $batwarningf ; BATS="" ;;
	$(( $BAT >   5 ))) echo "low" 	   > $batwarningf ; BATS=""   ; [ "$batlevel" == "healthy" ] && notify-send "Battery down to $BAT%!";;
	$(( $BAT <=  5 ))) echo "critical" > $batwarningf ;BATS=" "; [ "$batlevel" == "low" ]     && nwarn=$(echo -e "|\n|\n|         Battery down to $BAT%!         .\n|\n|") && notify-send -u critical "$nwarn" ;;
esac
echo "$BATS $BATC $BAT%"
