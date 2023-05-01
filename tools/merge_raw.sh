#!/bin/bash
#File merging for the EliadeSelector files

FIRSTrun=$1
LASTrun=$2
#volume1=$3
#volume2=$4
suffix=adqws

echo "Merge raw files for runs from $FIRSTrun to $LASTrun for all volumes "		

space=" "

runnb=$FIRSTrun

while test $runnb -le $LASTrun
do
	echo "=== I am in run $runnb ==="		
	volume1=0
	volnb=$volume1
	fileout="sum_run$runnb""_$volume1""_$volume1""_$suffix"."root"
	command="hadd sum_run$runnb""_$volume1""_$volume1""_$suffix"."root "


	if test -f "$fileout"
	   then
	   rm "$fileout"
	fi

  	flag=1 #1 - file found
	#current_file="run$runnb""_$volnb""_$suffix"".root"

	#echo "First file in run $runnb is $current_file"


	while test $flag -eq 1
	 do 
	 current_file="run$runnb""_$volnb""_$suffix"".root"
	 echo "current_file: $current_file"
	   if test -f "$current_file"
	   then
	     command="$command""$current_file""$space"
	     echo "$command"
	     volnb=$(($volnb + 1))
	     else 
		flag=0
	     break  
	   fi  
	done

	echo "$command"
	$command

        volnb=$(($volnb - 1)) #the last version found
#        filesave="sum_run$runnb""_$volume1""_$volnb""_$suffix"."root"
        filesave="run$runnb""_999""_$suffix"."root"
	mv $fileout $filesave
     runnb=$(($runnb + 1))
done
