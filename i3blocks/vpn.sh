#! /bin/bash
vpncity=$(cat $MEAD_PATH/.auxfiles/vpn/city)
if [ ${#vpncity} -gt 1 ]; then
	echo " $vpncity  |"
fi
