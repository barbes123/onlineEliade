#!/bin/bash

runnb1=$1
runnb2=${2:-$runnb}
volume1=${3:-0}
volume2=${4:-$volume1}
AddBAck=${5:-0}
server=${6:-10}
dvol=${7:-100}


echo "Put Parameters: AddBack (0 - if none); server_nbr (0 - if none); run_nbr; volume_from; volume_to;"

echo "RUNfirst      $runnb"
echo "RUNlast       $runnb1"
echo "VOLUMEfirst   $volume1"
echo "VOLUMElast    $volume2"
echo "ADDBACK       $AddBAck" # 1 - for Fold1; 0 - for HPGe_single
echo "SERVER ID     $server"
echo "INCRMENT	    $dvol"


runnb=$runnb1

while test $runnb -le $runnb2
do
    echo "Trying for run $runnb"
    volnb=$volume1
    while test $volnb -le $volume2
    do
    
#    name="addback_run_$runnb_""$volnb""_eliadeS$server.root"
    name="selected_run_""$runnb""_""$volnb""_eliadeS$server.root"  
    
    if [ -e "$name" ]; then
       echo "$name found"
    else
      echo "$name is missing"
      volnb=$(($volnb + $dvol))   
      continue
    fi

       
    
    echo "Now I am starting addback_me.C for $name"	

    rootcommand=$HOME/onlineEliade/tools/AddBackSimTools/addback_me.C+"($AddBAck,$server,$runnb,$volnb)"    
#    rootcommand="$HOME/onlineEliade/tools/AddBackSimTools/addback_me.C+\"($AddBack,$server,$runnb,$volnb)\""
    root -l -b -q $rootcommand    

    echo "I finished run$runnb"_"$volnb.root"
    if [ -f "addbackspectra.root" ]; then
	mv addbackspectra.root "addback_run_"$runnb"_""$volnb""_eliadeS$server.root"
    fi
    
        if [ -f "timespectra.root" ]; then
	mv timespectra.root "ts_run_"$runnb"_""$volnb""_eliadeS$server.root"
    fi	    
    	    
#    name="addback_run_$runnb_""$volnb""_eliadeS$server.root" 

    echo "Starting hconverter_ab.C"

    rootcommand=$HOME/onlineEliade/tools/AddBackSimTools/hconverter_ts.C"($runnb,$volnb,$server)"
    echo $rootcommand
    root -l -b -q "$rootcommand"
    volnb=$(($volnb + $dvol))          
    done
    runnb=$(($runnb + $dvol))  
done 



