#!/bin/bash
#File merging for the EliadeSelector files

FIRSTrun=$1
volume1=$2
volume2=$3
suffix=${4:-"eliadeS9"}

echo "Will run the selector for runs $FIRSTrun upto $LASTrun "
echo "Will run the selector for volumes $volume1 upto $volume2 "		

space=" "

runnb=$FIRSTrun
volnb=$volume1
fileout="sum_selected_run_$runnb""_$volume1""_$volume2""_$suffix"."root"
command="hadd sum_selected_run_$runnb""_$volume1""_$volume2""_$suffix"."root "


if test -f "$fileout"
   then
   rm "$fileout"
fi

while test $volnb -le $volume2
 do 
 current_file="selected_run_$runnb""_$volnb""_$suffix.root"
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
