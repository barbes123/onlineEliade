#!/bin/bash

CUR_DIR=$(pwd)
cd $CUR_DIR


fold1=${1:-0}
foldlast=${2:-$fold1}
energy=${3:-800}
activityCo60=10000000


echo "CUR_DIR $CUR_DIR"

echo "Add Back!"

prefix="sum_fold_1"
fold=1

echo "$prefix""_$fold.spe" 
 if test -f "$prefix""_$fold.spe" 
   then
   echo "Found Files"
   else
   echo "not found file"
 fi

echo "Will run the calib for domains $FIRSTdomain upto $LASTdomain "


##################################   
 if test -f "eliade.calib" 
   then 
   	rm "eliade.calib"   
   fi
##################################   
    if test -f "res.temp" 
   then 
   	rm "res.temp"   
   fi
##################################      
    if test -f "Co60.temp" 
   then 
   	rm "Co60.temp"   
   fi
##################################      
    if test -f "temp.calib" 
   then 
   	rm "temp.calib"   
   fi
##################################
    if test -f "resolution.txt" 
   then 
   	rm "resolution.txt"   
   fi
##################################
    if test -f "resolution_800.txt" 
   then 
   	rm "resolution_800.txt"   
   fi
##################################
   if test -f "resolution_1173.txt" 
   then 
   	rm "resolution_1173.txt"   
   fi
##################################
    if test -f "fulldata.calib" 
   then 
   	rm "fulldata.calib"   
   fi   
##################################      
    if test -f "data.calib" 
   then 
   	rm "data.calib"   
   fi
##################################            
lim1=50 lim2=1500 fwhm=4 ampl=1000

foldnbr=$fold1
maxfold=$foldlast

while test $foldnbr -le $maxfold
do
 echo "Now starting fold  $foldnbr"	
 
 
 if test -f "$prefix""_$fold.spe"
   then
      echo "  ~/EliadeSorting/EliadeTools/RecalEnergy -spe $filename -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl -v 2"
   
      filename="$prefix""_$foldnbr.spe"
      #get full data on calibration
      ~/EliadeSorting/EliadeTools/RecalEnergy -spe $filename -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl -ener $energy -v 2 
      ~/EliadeSorting/EliadeTools/RecalEnergy -spe $filename -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl -ener $energy -v 2  > fulldata.calib
      #delete first 14 lines
      awk 'NR > 14 { print }' fulldata.calib >  temp.calib
      
#      grep '800.00'  temp.calib >> res.temp
      
 #     exit
      
      echo -n "fold $foldnbr " >> eliade.calib      
  	##################################      
	if grep '800.00' temp.calib
	then
 	   grep '800.00'  temp.calib >> res.temp
 	   grep '800.00'  temp.calib >> Co60.temp      
 	   echo "Found 800.00"
	fi	
#	if grep '#2' res.temp
#	then
 #	   grep '#2'  res.temp >> data.calib      
# 	   echo "Found"
#	fi            
 #     else 
 #   	echo no file "$filename" 	
fi  
  
sed "1 s/./Fold $foldnbr\t&/" res.temp >res1.temp

cat data.calib res1.temp >> data.calib
#sed -i "s/#2/$foldnbr/" data.calib
#sed -i "s/#2/$foldnbr/" Co60.temp
 rm res.temp
 rm res1.temp
 rm temp.calib	
 foldnbr=$(($foldnbr + 1))
done 


awk -F " " '{ print $3 " " $6 " " $7 " " $11 " " $8 " " $9 " " $9/$8*$11 " keV" }' data.calib > resolution.txt 

awk -F " " '{ print $3 " " $6 " " $7 " " $11 " " $8 " " $9 " " $9/$8*$11 " [keV]; eff [%]: " $7/'$activityCo60'*100}' Co60.temp > eff_60Co.txt


grep '800.00' resolution.txt >> resolution_800.txt
grep '1172' resolution.txt >> resolution_1173.txt


counter=1

while IFS=$'\t' read -r col3; do
#    echo "Column 1: $col1"
    area=$(echo "$col3" | cut -d 't' -f 2)
#tr -s ' ' < columns.txt | cut -d" " -f2

#    area=$(echo "$col3" | cut -d 't' -f 2)
#    area=$(echo "$col1" | cut -d' ' -f1)
    echo "$area"
    areas[counter]=$area   
    counter=$(($counter + 1))
#done < resolution_800.txt
done < data.calib

exit
#echo "areas !!!" $areas

#for element in "${areas[@]}"; do
#    echo "$element"
#$done


# Loop through the array in reverse
length=${#areas[@]}

for (( i=2; i<=length; i++ )); do
#     ab=${areas[i]}/${areas[1]}
     a=${areas[i]}
     b=${areas[1]}
     echo "a $a b $b"
     echo "scale=4 ; $a / $b" | bc
#     echo $((a / b))

done


rm Co60.temp
#rm data.calib

