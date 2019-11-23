#! /bin/bash

city01="(1)  Madrid		(Spain)"
city02="(2)  Paris		(France)"
city03="(3)  Stockholm		(Sweden)"
city04="(4)  Amsterdam		(Netherlands)"
city05="(5)  HongKong		(Hong Kong)"
city06="(6)  Montreal		(Canada)"
city07="(7)  Tokyo		(Japan)"
city08="(8)  Frankfurt		(Germany)"
city09="(9)  London		(UK)"
city10="(10) Milan		(Italy)"
city11="(11) Zurich		(Switzerland)"
city12="(12) NewYork		(US, New York)"
city13="(13) Ashburn		(US, Virginia)"
city14="(14) Atlanta		(US, Georgia)"
city15="(15) Chicago		(US, Illinois)"
city16="(16) Dallas		(US, Texas)"
city17="(17) Denver		(US, Colorado)"
city18="(18) LosAngeles		(US, California)"
city19="(19) Miami		(US, Florida)"
city20="(20) SaltLakeCity	(US, Utah)"
city21="(21) SanJose		(US, California)"
city22="(22) Seattle		(US, Washington)"
city23="(23) Phoenix		(US, Arizona)"

numpars="$#"
PATHTOCONF="$MEAD_PATH2/vpn"
AUXPATH="$MEAD_PATH/.auxfiles/vpn"
CITYLIST="$city01
$city02
$city03
$city04
$city05
$city06
$city07
$city08
$city09
$city10
$city11
$city12
$city13
$city14
$city15
$city16
$city17
$city18
$city19
$city20
$city21
$city22
$city23"

if [ $numpars -eq 1 ]; then
	CONF=$1
elif [ $numpars -gt 1 ]; then
	echo "Expected one only parameter as top, but got $#"
	echo "Usage: ./openvpn.sh (city)"
	echo "To connect to privatetunnel VPN using that city's config file"
	exit 1
elif [ $numpars -eq 0 ]; then
	CONF=$(echo "$CITYLIST" | rofi -dmenu -p "Please enter the name of the config file you would like to use... Available cities)")
fi

[ ${#CONF} -lt 2 ] && exit

case $CONF in
	"$city01") FILE="Madrid.ovpn" ;;
	"$city02") FILE="Paris.ovpn" ;;
	"$city03") FILE="Stockholm.ovpn" ;;
	"$city04") FILE="Amsterdam.ovpn" ;;
	"$city05") FILE="HongKong.ovpn" ;;
	"$city06") FILE="Montreal.ovpn" ;;
	"$city07") FILE="Tokyo.ovpn" ;;
	"$city08") FILE="Frankfurt.ovpn" ;;
	"$city09") FILE="London.ovpn" ;;
	"$city10") FILE="Milan.ovpn" ;;
	"$city11") FILE="Zurich.ovpn" ;;
	"$city12") FILE="NewYork.ovpn" ;;
	"$city13") FILE="Ashburn.ovpn" ;;
	"$city14") FILE="Atlanta.ovpn" ;;
	"$city15") FILE="Chicago.ovpn" ;;
	"$city16") FILE="Dallas.ovpn" ;;
	"$city17") FILE="Denver.ovpn" ;;
	"$city18") FILE="LosAngeles.ovpn" ;;
	"$city19") FILE="Miami.ovpn" ;;
	"$city20") FILE="SaltLakeCity.ovpn" ;;
	"$city21") FILE="SanJose.ovpn" ;;
	"$city22") FILE="Seattle.ovpn" ;;
	"$city23") FILE="Phoenix.ovpn" ;;
esac

PATHF="$PATHTOCONF/$FILE"
CITYNAME=${FILE::-5}
echo "$CITYNAME" > $AUXPATH/city
pkill -SIGRTMIN+17 i3blocks

if [ ! -f $PATHF ]; then
	echo "Path specified does not exist"
	echo "($PATHF)"
	echo "" > $AUXPATH/city
	pkill -SIGRTMIN+17 i3blocks
	exit 2
elif [ ! ${PATHF: -5} == ".ovpn" ]; then
	echo "Path specified is not an openvpn config file (*.ovpn)"
	echo "Please use an openvpn config file"
	echo "" > $AUXPATH/city
	pkill -SIGRTMIN+17 i3blocks
	exit 3
fi

echo "Using $PATHF config file"

echo "This script needs ROOT Privileges"

sudo echo Running OpenVPN
sudo openvpn --verb 9 --writepid $AUXPATH/pidf --config $PATHF
echo "" > $AUXPATH/pidf
echo "" > $AUXPATH/city
pkill -SIGRTMIN+17 i3blocks
