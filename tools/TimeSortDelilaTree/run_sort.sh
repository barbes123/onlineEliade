#!/bin/bash

runnb=$1
volume1=$2
volume2=$3

#suffix="ssgant1"
suffix=${4:-"ssgant1"}

echo "Put Parameters: run_nbr; volume_from; volume_to"
echo "Now starting run the selector $runnb"	

volnb=$volume1

while test $volnb -le $volume2
do 
echo "file: run$runnb""_""$volnb"_"$suffix.root" 
  if test -f "run$runnb""_""$volnb"_"$suffix.root"
  then
   echo "file: run$runnb""_""$volnb"_"$suffix.root FOUND"
   rootcommand=sort.cpp"($runnb,$volnb)"  
   echo "$rootcommand"
   root -l -b -q $rootcommand  
  fi  
 volnb=$(($volnb + 1))  
done


