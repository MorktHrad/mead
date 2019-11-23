#! /bin/bash

wifiinterface=$(ip a | grep 3: | grep -v link | awk '{print $2}')
wifiinterface=${wifiinterface:: -1}

#Location of config files
pathtofiles="$MEAD_PATH2/hotspot/"

#Asking for SSID or option...
Setting=$(cat $pathtofiles/wifis | rofi -dmenu)

#Escape = Quit
if [ ${#Setting} -lt 1 ]; then
	echo "No setting specified"
	exit 0
fi

#If add hotspot
if [ "$Setting" == "# Add New Hotspot... #" ]; then
	echo "Adding new Hotspot..."
	SSID=$(echo "Type in a SSID, then press enter..." | rofi -dmenu)
	password=$(echo "Type in a Password, then press enter..." | rofi -dmenu)
	password2=$(echo "Retype Password..." | rofi -dmenu)
	if [ "$password" == "$password2" ]; then
		echo ""
		sed -i "$ d" "$pathtofiles/wifis"
		sed -i "$ d" "$pathtofiles/wifis"				#Removing Options from wifi file
		echo $SSID >> "$pathtofiles/wifis"			#Adding new SSID to wifi file
		echo "$SSID $password" >> "$pathtofiles/logkeys"		#Adding new SSID and Password to logkeys file
		echo "# Add New Hotspot... #" >> "$pathtofiles/wifis"
		echo "# Remove a Hotspot.. #" >> "$pathtofiles/wifis"	#Adding options again

		#Asking to connect to new hotspot
		conyn=$(echo -e "Yes\nNo\nActivate this hotspot?" | rofi -dmenu)
		if [ ${#conyn} -gt 1 ] && [ $conyn == "Yes" ]; then
			Setting="$SSID"
			Settingf="$SSID $password"
		else
			exit 0
		fi
	else
		echo -e "\nPasswords don't match" 			#If passwords didnt match
		exit 1
	fi

#If remove Hotspot
elif [ "$Setting" == "# Remove a Hotspot.. #" ]; then
	Setting=$(cat $pathtofiles/wifis | rofi -dmenu)			#Show list again
	if [ "$Setting" == "# Add New Hotspot... #" ] || [ "$Setting" == "# Remove a Hotspot.. #" ]; then
		echo "Please enter a valid hotspot to remove..."
		exit 1
	else
		echo "Removing $Setting"	#Warn user
		tempfile=$(mktemp)
		while read ssidc; do
			if ! [ "$ssidc" == "$Setting" ]; then
				echo "$ssidc" >> "$tempfile"
			fi
		done < "$pathtofiles/wifis"
		cat $tempfile > $pathtofiles/wifis
		rm $tempfile

		tempfile=$(mktemp)
		while read ssidc pass; do
			if ! [ "$ssidc" == "$Setting" ]; then
				echo "$ssidc $pass" >> "$tempfile"
			fi
		done < "$pathtofiles/logkeys"
		cat $tempfile > $pathtofiles/logkeys
		rm $tempfile
		echo "Removed $Setting from hotspot list"
		exit 0
	fi
else
	Settingf=$(cat $pathtofiles/logkeys | grep -w "$Setting")
fi

echo "Will activate $Setting hotspot..."

didsudo="no"
didsudo=$(sudo echo "yes")
if [ $didsudo == "no" ]; then
	echo "This script needs root privileges..."
	exit 2
fi

echo "$Setting" > $MEAD_PATH/.auxfiles/hotspotname
pkill -SIGRTMIN+15 i3blocks

currSSID=$(iwconfig $wifiinterface | grep ESSID | awk '{print $4}')
if [ "$currSSID" == "ESSID:off/any" ]; then
	echo "No connection to deactivate"
else
	currSSID=${currSSID#*'"'}; currSSID=${currSSID%'"'*}
	nmcli con down $currSSID
fi
sudo create_ap $wifiinterface $wifiinterface $Settingf

echo "" > $MEAD_PATH/.auxfiles/hotspotname
pkill -SIGRTMIN+15 i3blocks
