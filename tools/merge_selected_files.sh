#!/bin/bash
#File merging for the EliadeSelector files

FIRSTrun=$1
LASTrun=$2
volume1=$3
#volume2=$4
suffix=eliadeS1
prefix=selected_run

echo "Merge raw files for runs from $FIRSTrun to $LASTrun for all volumes "		

space=" "

runnb=$FIRSTrun

fileout="sum_$prefix""_$FIRSTrun""_$LASTrun""_$volume1""_$suffix"."root"

echo "$fileout"


if test -f "$fileout"
   then
   rm "$fileout"
fi

command="hadd $fileout"" "

while test $runnb -le $LASTrun
do
	current_file="$prefix""_$runnb""_$volume1""_$suffix"".root"
	if test -f "$current_file"
	then
		command="$command""$current_file""$space"
		echo "Found file $current_file"
	fi  
	runnb=$(($runnb + 1))
done

echo "$command"
$command
