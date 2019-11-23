#! /bin/bash
#################
# SCRIPT CONFIG #
#################

scriptloc=$MEAD_PATH/assignments
horariofile=assignments.txt
bkfile=.horario.txt.backup
dmenuc="rofi -dmenu"


helpmenu="A script for showing a schedule.
USAGE: Script.sh <options> [arguments]
Available options:
-s:	Show assignments in given date.
	Usage:
		Script.sh -s [DD/MM/YYYY]
		If no date specified, will show for today
-e:	Edit assignments file
-h:	Show this menu and exit
-b:	Show next assignment to end formatted to fit the bar
-r:	Repair the assignments file"

typelist="Teoría
Laboratorio
Problemas
Seminario
Examen
Extraescolar
Social"

###########
# PROMPTS #
###########

	#Edit prompts:
	addass="1) Add an assignment"
	remass="2) Remove an existing assignment"
	checkd="3) Check for assignments on a given date"

	#Date selector
	todayprompt="1) Add for today"
	anothprompt="2) Add for another day"

	eventprompt="Please specify a date and a starting time. Format: DD/MM/YYYY@HH:MM"
	timeprompt="Please specify a time. Format: HH:MM"
	dateprompt="Please specify a date. Format: DD/MM/YYYY"
	durprompt="How much does it last for? Format: HH:MM"
	typeprompt="Which type of activity is it?"
	nameprompt="Please type the name of the assignment"

	noclassadv="No assignments in sight!"

#############
# FUNCTIONS #
#############

addAssignment(){
	if [ ${#1} == 10 ]; then
		addmode=$anothprompt
		askmode="cliah"
	elif [ ${#1} == 16 ]; then
		addmode=$anothprompt
		askmode="clicm"
	else
		addmode=$(echo -e "$todayprompt\n$anothprompt" | $dmenuc)
		if [ "${#addmode}" -lt 5 ]; then
			exit
		fi
	fi
	case $addmode in
		$todayprompt)
			iday=$(date +%d)
			imth=$(date +%m)
			iyrr=$(date +%Y)
			itime=$(echo "$timeprompt" | $dmenuc)
			if [ ${#itime} -ne 5 ]; then
				exit
			fi
			itime=$(parseTime $itime)
			ihrr=$(echo "$itime" | awk '{print $1}')
			imin=$(echo "$itime" | awk '{print $2}')
			;;
		$anothprompt)
			if [ "$askmode" == "cliah" ]; then
				itime=$(echo "$timeprompt" | $dmenuc)
				if [ ${#itime} -ne 5 ]; then
					exit
				fi
				idate="$1@$itime"
			elif [ "$askmode" == "clicm" ]; then
				idate="$1"
			else
				idate=$(echo "$eventprompt" | $dmenuc)
				if [ ${#idate} -ne 16 ]; then
					exit
				fi
			fi
			idate=$(parseBoth $idate)
			iday=$(echo "$idate" | awk '{print $1}')
			imth=$(echo "$idate" | awk '{print $2}')
			iyrr=$(echo "$idate" | awk '{print $3}')
			ihrr=$(echo "$idate" | awk '{print $4}')
			imin=$(echo "$idate" | awk '{print $5}')
			;;
	esac

	# quiet=$(echo "Adding for $iday-$imth-$iyrr at $ihrr:$imin" | $dmenuc)
	assname=$(echo "$nameprompt" | $dmenuc)
	[ ${#assname} -lt 1 ] && exit
	assdurr=$(echo "$durprompt" | $dmenuc)
	[ ${#assdurr} -lt 1 ] && exit
	asstype=$(echo -e "$typeprompt$typelist" | $dmenuc)
	[ ${#asstype} -lt 1 ] && exit
	asstype=$(unParseCode $asstype)

	echo "$iday/$imth/$iyrr $ihrr:$imin $assdurr X X $asstype $assname" >> $scriptloc/$horariofile

	quiet=$(echo "Adding $assname $asstype at date $iday-$imth-$iyrr at $ihrr:$imin with duration $assdurr" | $dmenuc)

}

editInDate(){
	editoption=$(echo -e "$addass\n$remass\n$checkd" | $dmenuc)

	case $editoption in
		$addass) addAssignment $1 ;;
		$remass) remAssignment $1 ;;			#
		$checkd) idate=$(echo "$dateprompt" | $dmenuc) ; [ ${#idate} -eq 10 ] && quiet=$(getInDate $idate | $dmenuc) ;;
	esac
}

remAssignment(){
	if [ ${#1} -eq 10 ]; then
		idate=$1
	else
		idate=$(echo "$dateprompt" | $dmenuc)
		[ ${#idate} -ne 10 ] && idate=$(date +%d/%m/%Y)
	fi
	asstorem=$(cat $scriptloc/$horariofile | grep $idate | $dmenuc)
	[ ${#asstorem} -lt 10 ] && exit
	tmphorario=$(mktemp)
	cat $scriptloc/$horariofile | grep -v "$asstorem" > $tmphorario
	cat $tmphorario > $scriptloc/$horariofile
}

parseCode(){
	code=$1
	code=${code: -3}
	code=${code::2}
	case $code in
		"TE") echo "Teoría"		;;
		"LA") echo "Laboratorio"	;;
		"PR") echo "Problemas"		;;
		"SE") echo "Seminario"		;;
		"EX") echo "Examen"		;;
		"ES") echo "Extraescolar"	;;
		"SO") echo "Social"		;;
	esac
}

unParseCode(){
	ptype=$1
	case $ptype in
		"Teoría") 	echo "MTXXXX-TEX"	;;
		"Laboratorio") 	echo "MTXXXX-LAX"	;;
		"Problemas") 	echo "MTXXXX-PRX"	;;
		"Seminario")	echo "MTXXXX-SEX"	;;
		"Examen")	echo "MTXXXX-EXX"	;;
		"Extraescolar")	echo "MTXXXX-ESX"	;;
		"Social")	echo "MTXXXX-SOX"	;;
	esac

}

formatAssignments(){

	tmpformat=$(mktemp)
	tmpinput=$1

	# echo -e "Start\t End\t\tType Name" >> $tmpformat
	echo -e "\t    Type Start   Until Name" >> $tmpformat

	while read DATE START DUR CODE NAME; do
		#Parsing start time string
		START=$(addZero $START)
		parsedstart=$(parseTime $START)
		shrr=$(echo "$parsedstart" | awk '{print $1}')
		shrra=$(stripZero $shrr)
		smin=$(echo "$parsedstart" | awk '{print $2}')
		smina=$(stripZero $smin)

		#Parsing duration time string
		DUR=$(addZero $DUR)
		parseddur=$(parseTime $DUR)
		dhrr=$(echo "$parseddur" | awk '{print $1}')
		dhrra=$(stripZero $dhrr)
		dmin=$(echo "$parseddur" | awk '{print $2}')
		dmina=$(stripZero $dmin)

		#Getting end time
		fhrra=$(($dhrra + $shrra))
		fmina=$(($dmina + $smina))
		fmin=$(addZeroTwo $fmina)
		if [ $fmin == "60" ]; then
			fmin="00"
			fhrra=$(($fhrra + 1))
		fi
		fhrr=$(addZeroTwo $fhrra)

		classtype=$(parseCode $CODE)
		classtype="($classtype)"

		# case ${#classtype} in
		# 	1)  classtype="       $classtype        " ;;
		# 	2)  classtype="       $classtype       "  ;;
		# 	3)  classtype="      $classtype       "   ;;
		# 	4)  classtype="      $classtype      "    ;;
		# 	5)  classtype="     $classtype      "     ;;
		# 	6)  classtype="     $classtype     "      ;;
		# 	7)  classtype="    $classtype     "       ;;
		# 	8)  classtype="    $classtype    "        ;;
		# 	9)  classtype="   $classtype    "         ;;
		# 	10) classtype="   $classtype   "          ;;
		# 	11) classtype="  $classtype   "           ;;
		# 	12) classtype="  $classtype  "            ;;
		# 	13) classtype=" $classtype  "             ;;
		# 	14) classtype=" $classtype "              ;;
		# 	15) classtype="$classtype "               ;;
		# 	16) classtype="$classtype"                ;;
		# esac

		case ${#classtype} in
			1)  classtype="               $classtype" ;;
			2)  classtype="              $classtype"  ;;
			3)  classtype="             $classtype"   ;;
			4)  classtype="            $classtype"    ;;
			5)  classtype="           $classtype"     ;;
			6)  classtype="          $classtype"      ;;
			7)  classtype="         $classtype"       ;;
			8)  classtype="        $classtype"        ;;
			9)  classtype="       $classtype"         ;;
			10) classtype="      $classtype"          ;;
			11) classtype="     $classtype"           ;;
			12) classtype="    $classtype"            ;;
			13) classtype="   $classtype"             ;;
			14) classtype="  $classtype"              ;;
			15) classtype=" $classtype"               ;;
			16) classtype="$classtype"                ;;
		esac

		echo -e "$classtype $shrr:$smin - $fhrr:$fmin $NAME" >> $tmpformat

	done < $tmpinput

	cat $tmpformat > $tmpinput
	rm $tmpformat
}

getInDate(){
	#Date format: DD?MM?YYYY
	if [ ${#1} -eq 10 ]; then
		idate=$(parseDate $1)
		iday=$(echo $idate | awk '{print $1}')
		imth=$(echo $idate | awk '{print $2}')
		iyrr=$(echo $idate | awk '{print $3}')
	else
		iday=$(date +%d)
		imth=$(date +%m)
		iyrr=$(date +%Y)
	fi
	tmpshow=$(mktemp)
	lessons=$(cat $scriptloc/$horariofile | grep "$iday/$imth/$iyrr")
	echo "$lessons" > $tmpshow


	if [ ${#lessons} -lt 2 ]; then
		echo "$noclassadv"
	else
		formatAssignments $tmpshow
		# TODO: Sort lessons
		cat $tmpshow
	fi
	rm $tmpshow
}

showInDateNot(){
	notify-send -t 0 "$(getInDate $1)"
}

showForBar(){
	#Date format: DD?MM?YYYY?HH?MM
	if [ ${#1} -eq  16 ]; then
		idate=$(parseBoth $1)
		iday=$(echo $idate | awk '{print $1}')
		imth=$(echo $idate | awk '{print $2}')
		iyrr=$(echo $idate | awk '{print $3}')
		ihrr=$(echo $idate | awk '{print $4}')
		imin=$(echo $idate | awk '{print $5}')
	else
		iday=$(date +%d)
		imth=$(date +%m)
		iyrr=$(date +%Y)
		ihrr=$(date +%H)
		imin=$(date +%M)
	fi

	#echo $iday/$imth/$iyrr @ $ihrr:$imin
	tmpbar=$(mktemp)

	getLessonsInDate $iday $imth $iyrr $tmpbar

	class=$(getShowClass $ihrr $imin $tmpbar)
	echo $class

	rm $tmpbar
}

stripZero(){
	if [ ${1::1} == "0" ]; then
		echo ${1:1}
	else
		echo $1
	fi
}

addZero(){
	if [ ${#1} == 4 ]; then
		echo "0$1"
	else
		echo "$1"
	fi
}

addZeroTwo(){
	if [ ${#1} == 1 ]; then
		echo "0$1"
	else
		echo "$1"
	fi
}

getShowClass(){

	#Input date values
	ihrr=$(stripZero $1)
	imin=$(stripZero $2)
	ifil=$(stripZero $3)
	ival=$(($imin + 60*$ihrr))

	#Loop variables
	candval=100000
	showassignment="n"

	#Debug things
	#echo "'Current time: $ival'"

	#Reading classes in file
	while read DAY START DUR CODE NAME; do

		#Parsing start time string
		START=$(addZero $START)
		parsedstart=$(parseTime $START)
		shrr=$(echo "$parsedstart" | awk '{print $1}')
		shrr=$(stripZero $shrr)
		smin=$(echo "$parsedstart" | awk '{print $2}')
		smin=$(stripZero $smin)
		sval=$(($smin + 60*$shrr))

		#Parsing duration time string
		DUR=$(addZero $DUR)
		parseddur=$(parseTime $DUR)
		dhrr=$(echo "$parseddur" | awk '{print $1}')
		dhrr=$(stripZero $dhrr)
		dmin=$(echo "$parseddur" | awk '{print $2}')
		dmin=$(stripZero $dmin)
		dval=$(($dmin + 60*$dhrr))

		#Getting end time
		fhrr=$(($dhrr + $shrr))
		fmin=$(($dmin + $smin))
		if [ $fmin == "60" ]; then
			fmin=00
			fhrr=$(($fhrr + 1))
		fi
		fval=$(($fmin + 60*$fhrr))

		#Debug things
		#echo "'Start $sval Duration $dval End $fval'"

		#Checking if lesson is valid to show...
		if [ $fval -gt $ival ] && [ $fval -lt $candval ]; then
				showassignment="y"
				candval=$fval
				outclass=$NAME
				outcode=$CODE
				strs="$(addZeroTwo $shrr):$(addZeroTwo $smin)"
				strf="$(addZeroTwo $fhrr):$(addZeroTwo $fmin)"
		fi
	done < $ifil

	#Parsing code
	assignmentType=$(parseCode $outcode)

	#Outputting text for bar
	if [ $showassignment == "y" ]; then
		# echo " $strs  $strf  $outclass ($assignmentType)"
		# echo " $strs - $strf $outclass ($assignmentType)"
		echo " $strs - $strf $outclass"
	fi

}

getLessonsInDate(){
	cat $scriptloc/$horariofile | grep "$1/$2/$3" > $4
}

parseDate(){
	#Date format: DD?MM?YYYY
	inputdate=$1
	year=${inputdate: -4}
	day=${inputdate::2}
	month=${inputdate::5}
	month=${month: -2}

	echo "$day $month $year"
}
parseTime(){
	#Time format: HH?MM
	inputtime=$1
	hour=${inputtime::2}
	minutes=${inputtime: -2}

	echo "$hour $minutes"
}

parseBoth(){
	inputtime=${1: -5}
	inputdate=${1:: 10}
	date=$(parseDate $inputdate)
	time=$(parseTime $inputtime)
	echo "$date $time"
}

repairFile(){
	quiet=$(rm $scriptloc/$horariofile 2>&1)
	cp $scriptloc/$bkfile $scriptloc/$horariofile
}

################
# MAIN PROGRAM #
################

option=$1

case $option in
	-h)	echo -e "$helpmenu" ;;
	-s)	showInDateNot $2 ;;
	-e)	editInDate $2 ;;
	-b)	showForBar $2 ;;
	-r)	repairFile ;;
esac
