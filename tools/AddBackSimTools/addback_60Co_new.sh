#!/bin/bash

CUR_DIR=$(pwd)
cd $CUR_DIR


run=${1:-4}
fold1=${2:-0}
foldlast=${3:-$fold1}
energy1=${4:-800}
energy2=${5:-$energy1}
activityCo60=${6:-50000000}

server=10

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

echo "Will run the calib for folds $fold1 upto $foldlast "


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
lim1=50 lim2=4000 fwhm=4 ampl=1000

foldnbr=$fold1
maxfold=$foldlast


energy=$energy1

while test $energy -le $energy2
do
 echo "Now starting for energy  $energy"	
 
while test $foldnbr -le $maxfold
do
 echo "Now starting fold  $foldnbr"	
 
 
# if test -f "$prefix""_$fold.spe"
 #  then
      path="addback_run_"$run"_$energy"_eliadeS"$server"
      filename="$prefix""_$foldnbr.spe"
      
      echo "File name:" $filename 
          
 
      if ! test -f $filename 
      then 
         filename=$path"/"$filename
         echo "No file "$filename
      fi
      
      if ! test -f $filename
      then 
      	 echo "No file "$filename
      	 exit
      else
         echo "File name:" $filename 

      echo "  ~/EliadeSorting/EliadeTools/RecalEnergy -spe $filename -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl -v 2"
      #get full data on calibration
      ~/EliadeSorting/EliadeTools/RecalEnergy -spe $filename -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl -ener $energy -v 2 
      ~/EliadeSorting/EliadeTools/RecalEnergy -spe $filename -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl -ener $energy -v 2  > fulldata.calib
      
       if -f $energy -eq "1400"
      	then
           enery=140
       fi
      
      #delete first 14 lines
      awk 'NR > 14 { print }' fulldata.calib >  temp.calib
      echo -n "fold $foldnbr " >> eliade.calib      
      #################################     
      
      
     
     
	if grep '100.00' temp.calib
	then
 	   grep '100.00'  temp.calib >> res.temp
 	   grep '100.00'  temp.calib >> Co60.temp      
 	   echo "Found 100.00"
 	elif grep '200.00' temp.calib
 	   then
 	   grep '200.00'  temp.calib >> res.temp
 	   grep '200.00'  temp.calib >> Co60.temp      
 	   echo "Found 200.00"
 	elif grep '300.00' temp.calib
 	   then
 	   grep '300.00'  temp.calib >> res.temp
 	   grep '300.00'  temp.calib >> Co60.temp      
 	   echo "Found 300.00"
       elif grep '400.00' temp.calib
 	   then
 	   grep '400.00'  temp.calib >> res.temp
 	   grep '400.00'  temp.calib >> Co60.temp      
 	   echo "Found 400.00"
 	elif grep '500.00' temp.calib
 	   then
 	   grep '500.00'  temp.calib >> res.temp
 	   grep '500.00'  temp.calib >> Co60.temp      
 	   echo "Found 500.00"   
 	elif grep '600.00' temp.calib
 	   then
 	   grep '600.00'  temp.calib >> res.temp
 	   grep '600.00'  temp.calib >> Co60.temp      
 	   echo "Found 600.00"
 	elif grep '700.00' temp.calib
 	   then
 	   grep '700.00'  temp.calib >> res.temp
 	   grep '700.00'  temp.calib >> Co60.temp      
 	   echo "Found 700.00"
 	elif grep '800.00' temp.calib
 	   then
 	   grep '800.00'  temp.calib >> res.temp
 	   grep '800.00'  temp.calib >> Co60.temp      
 	   echo "Found 800.00"
 	elif grep '900.00' temp.calib
 	   then
 	   grep '900.00'  temp.calib >> res.temp
 	   grep '900.00'  temp.calib >> Co60.temp      
 	   echo "Found 900.00"
	elif grep '1000.00' temp.calib
 	   then
 	   grep '1000.00'  temp.calib >> res.temp
 	   grep '1000.00'  temp.calib >> Co60.temp      
 	   echo "Found 1000.00"
	elif grep '1100.00' temp.calib
 	   then
 	   grep '1100.00'  temp.calib >> res.temp
 	   grep '1100.00'  temp.calib >> Co60.temp      
 	   echo "Found 1100.00"
	elif grep '1200.00' temp.calib
 	   then
 	   grep '1200.00'  temp.calib >> res.temp
 	   grep '1200.00'  temp.calib >> Co60.temp      
 	   echo "Found 1200.00"
	elif grep '1300.00' temp.calib
 	   then
 	   grep '1300.00'  temp.calib >> res.temp
 	   grep '1300.00'  temp.calib >> Co60.temp      
 	   echo "Found 1300.00"
 	elif grep '140.0' temp.calib
 	   then
 	   grep '140.0'  temp.calib >> res.temp
 	   grep '140.0'  temp.calib >> Co60.temp      
 	   echo "Found 1400."
	elif grep '1500.00' temp.calib
 	   then
 	   grep '1500.00'  temp.calib >> res.temp
 	   grep '1500.00'  temp.calib >> Co60.temp      
 	   echo "Found 1500.00"
 	 elif grep '1600.00' temp.calib
 	   then
 	   grep '1600.00'  temp.calib >> res.temp
 	   grep '1600.00'  temp.calib >> Co60.temp      
 	   echo "Found 1600.00"
	 elif grep '1700.00' temp.calib
 	   then
 	   grep '1700.00'  temp.calib >> res.temp
 	   grep '1700.00'  temp.calib >> Co60.temp      
 	   echo "Found 1700.00"  
	 elif grep '1800.00' temp.calib
 	   then
 	   grep '1800.00'  temp.calib >> res.temp
 	   grep '1800.00'  temp.calib >> Co60.temp      
 	   echo "Found 1800.00"   
 	 elif grep '1900.00' temp.calib
 	   then
 	   grep '1900.00'  temp.calib >> res.temp
 	   grep '1900.00'  temp.calib >> Co60.temp      
 	   echo "Found 1900.00"   
       elif grep '2000.00' temp.calib
	then
	    grep '2000.00' temp.calib >> res.temp
	    grep '2000.00' temp.calib >> Co60.temp
	    echo "Found 2000.00"
	elif grep '2100.00' temp.calib
then
    grep '2100.00' temp.calib >> res.temp
    grep '2100.00' temp.calib >> Co60.temp
    echo "Found 2100.00"
elif grep '2200.00' temp.calib
then
    grep '2200.00' temp.calib >> res.temp
    grep '2200.00' temp.calib >> Co60.temp
    echo "Found 2200.00"
elif grep '2300.00' temp.calib
then
    grep '2300.00' temp.calib >> res.temp
    grep '2300.00' temp.calib >> Co60.temp
    echo "Found 2300.00"
elif grep '2400.00' temp.calib
then
    grep '2400.00' temp.calib >> res.temp
    grep '2400.00' temp.calib >> Co60.temp
    echo "Found 2400.00"
elif grep '2500.00' temp.calib
then
    grep '2500.00' temp.calib >> res.temp
    grep '2500.00' temp.calib >> Co60.temp
    echo "Found 2500.00"
elif grep '2600.00' temp.calib
then
    grep '2600.00' temp.calib >> res.temp
    grep '2600.00' temp.calib >> Co60.temp
    echo "Found 2600.00"
elif grep '2700.00' temp.calib
then
    grep '2700.00' temp.calib >> res.temp
    grep '2700.00' temp.calib >> Co60.temp
    echo "Found 2700.00"
elif grep '2800.00' temp.calib
then
    grep '2800.00' temp.calib >> res.temp
    grep '2800.00' temp.calib >> Co60.temp
    echo "Found 2800.00"
elif grep '2900.00' temp.calib
then
    grep '2900.00' temp.calib >> res.temp
    grep '2900.00' temp.calib >> Co60.temp
    echo "Found 2900.00"
elif grep '3000.00' temp.calib
then
    grep '3000.00' temp.calib >> res.temp
    grep '3000.00' temp.calib >> Co60.temp
    echo "Found 3000.00"
elif grep '3100.00' temp.calib
then
    grep '3100.00' temp.calib >> res.temp
    grep '3100.00' temp.calib >> Co60.temp
    echo "Found 3100.00"
elif grep '3200.00' temp.calib
then
    grep '3200.00' temp.calib >> res.temp
    grep '3200.00' temp.calib >> Co60.temp
    echo "Found 3200.00"
elif grep '3300.00' temp.calib
then
    grep '3300.00' temp.calib >> res.temp
    grep '3300.00' temp.calib >> Co60.temp
    echo "Found 3300.00"
elif grep '3400.00' temp.calib
then
    grep '3400.00' temp.calib >> res.temp
    grep '3400.00' temp.calib >> Co60.temp
    echo "Found 3400.00"
elif grep '3500.00' temp.calib
then
    grep '3500.00' temp.calib >> res.temp
    grep '3500.00' temp.calib >> Co60.temp
    echo "Found 3500.00"
elif grep '3600.00' temp.calib
then
    grep '3600.00' temp.calib >> res.temp
    grep '3600.00' temp.calib >> Co60.temp
    echo "Found 3600.00"
elif grep '3700.00' temp.calib
then
    grep '3700.00' temp.calib >> res.temp
    grep '3700.00' temp.calib >> Co60.temp
    echo "Found 3700.00"
elif grep '3800.00' temp.calib
then
    grep '3800.00' temp.calib >> res.temp
    grep '3800.00' temp.calib >> Co60.temp
    echo "Found 3800.00"
elif grep '3900.00' temp.calib
then
    grep '3900.00' temp.calib >> res.temp
    grep '3900.00' temp.calib >> Co60.temp
    echo "Found 3900.00"
elif grep '4000.00' temp.calib
then
    grep '4000.00' temp.calib >> res.temp
    grep '4000.00' temp.calib >> Co60.temp
    echo "Found 4000.00"

 	else
 	   echo "modify script add energy" 
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
sed -i "s/#2/$foldnbr/" data.calib
#sed -i "s/#2/$foldnbr/" Co60.temp

 rm res.temp
 rm res1.temp
# rm temp.calib	
 foldnbr=$(($foldnbr + 1))
done 



#awk -F " " '{ print $3 " " $6 " " $7 " " $11 " " $8 " " $9 " " $9/$8*$11 " keV" }' data.calib > resolution.txt 

#awk -F " " '{ print $3 " " $6 " " $7 " " $11 " " $8 " " $9 " " $9/$8*$11 " [keV]; eff [%]: " $7/'$activityCo60'*100}' Co60.temp > fold_data.txt
awk -F " " '{ print $2 " " $5 " " $8 " " $9 " " $13 " " $10 " " $11 " " $11/$10*$13 " [keV]; eff [%]: " $9/'$activityCo60'*100}' data.calib > fold_data.txt


divisor=$(awk 'NR==1 {print $6}' fold_data.txt) #fold1
errdivisor=$(awk "BEGIN {print sqrt($divisor)}")
errdivisor=$(awk "BEGIN {print 1 / $errdivisor}")

echo 'divisor' $divisor 'err' $errdivisor

#exit

#echo $divisor

#awk '{print $5, $5/10}' fold_data.txt

echo "Energy "$energy
#awk -v divisor="$divisor" '{print $1, $6 / divisor}' fold_data.txt
awk -v divisor="$divisor" '{printf "%s %s ", $1, $6 / divisor}' fold_data.txt
echo ""

echo -n "Energy "$energy" " > add_back_$energy.txt
#awk -v divisor="$divisor" '{printf "%s %s ", $1, $6 / divisor}' fold_data.txt >> add_back_$energy.txt
awk -v divisor="$divisor" '{printf "%s %s %s", $1, $6 / divisor, (1 / sqrt($6) + errdivisor) }' fold_data.txt >> add_back_$energy.txt

#tried to print errors
#awk -v divisor="$divisor" -v errdivisor="$errdivisor" '{
#    printf "%s %s %s\n", $1, $6 / divisor, (1 / sqrt($6) + errdivisor)
#}' fold_data.txt >> add_back_$energy.txt


echo -n "Energy "$energy" " >> add_back_all_run$run.txt
awk -v divisor="$divisor" '{printf "%s %s %s %s ", $1, $6, divisor, $6 / divisor}' fold_data.txt >> add_back_all_run$run.txt
#tried to print errors
#awk -v divisor="$divisor" -v errdivisor="$errdivisor" '{
#    printf "%s %s %s\n", $1, $6 / divisor, (1 / sqrt($6) + errdivisor)
#}' fold_data.txt >>  add_back_all_run$run.txt
echo "" >> add_back_all_run$run.txt

 energy=$(($energy + 100))
done
