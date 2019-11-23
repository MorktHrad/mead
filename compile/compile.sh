#! /bin/bash

[ ${#1} -lt 2 ] || [ ! -f $1 ] && exit 1

#FUNCTIONS
compileclang(){
	base="${1:: -2}"
	gcc $1 -o $base $compileargs -pthread || { echo -e "\n\nErrors compiling. Aborting run\n" && exit 2 ; }
	printf "Compiled correctly\n$base "
	read args
	$base $args
}

compilecpp(){
	base="${1:: -4}"
	c++ $1 -o $base $compileargs -pthread || { echo -e "\n\nErrors compiling. Aborting run\n" && exit 2 ; }
	printf "Compiled correctly\n$base "
	read args
	$base $args
}

########
# MAIN #
########

#Getting extra arguments for compiler
compileargs=""
for i in "${@:2}"
do
    compileargs="$compileargs $i"
done

#Executing compile function
case $1 in
	*\.c) compileclang $1 ;;
	*\.cpp) compilecpp $1 ;;
	*) echo Unrecognized file extension. Aborting compile;;
esac
