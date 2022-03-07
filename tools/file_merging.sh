#!/bin/bash
#File merging for the EliadeSelector files

server=$1
FIRSTrun=$2
volume1=$3
volume2=$4

echo "Will run the selector for runs $FIRSTrun upto $LASTrun "
echo "Will run the selector for volumes $volume1 upto $volume2 "		


space=" "

runnb=$FIRSTrun
volnb=$volume1
command="hadd selected_run_$runnb""_eliadeS$server"."root "

fileout="selected_run_$runnb""_eliadeS$server"."root";
echo "summed file: $fileout"


if test -f ""
   then
   rm "$fileout"
fi

while test $volnb -le $volume2
 do 
 current_file="selected_run_$runnb""_$volnb""_eliadeS$server.root"
 echo "current_file: $current_file"
   if test -f "$current_file"
   then
     command="$command""$current_file""$space"
     echo "$command"
     volnb=$(($volnb + 1))
     else 
     break  
   fi  
done

echo "$command"
$command
