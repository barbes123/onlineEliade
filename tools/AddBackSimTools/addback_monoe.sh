#!/bin/bash

CUR_DIR=$(pwd)
cd $CUR_DIR


run=${1:-4}
fold1=${2:-0}
foldlast=${3:-$fold1}
energy1=${4:-800}
energy2=${5:-$energy1}
activity=${6:-10000000} #nevents from simulations

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

tput setaf 4; echo "Will run for Energies $energy1 $energy2 and folds $fold1 upto $foldlast ";tput sgr0;

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
	
           
lim1=50 lim2=4000 fwhm=4 ampl=1000


maxfold=$foldlast


energy=$energy1

while test $energy -le $energy2
do

 	echo "Now starting for energy  $energy"	
 	foldnbr=$fold1
 	
 	##################################      
	if test -f "data.calib" 
	   then 
	   	rm "data.calib"   
	fi
	################################## 
 
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
#	 	   grep '100.00'  temp.calib >> Co60.temp      
	 	   echo "Found 100.00"
	 	elif grep '200.00' temp.calib
	 	   then
	 	   grep '200.00'  temp.calib >> res.temp
#	 	   grep '200.00'  temp.calib >> Co60.temp      
	 	   echo "Found 200.00"
	 	elif grep '300.00' temp.calib
	 	   then
	 	   grep '300.00'  temp.calib >> res.temp
#	 	   grep '300.00'  temp.calib >> Co60.temp      
	 	   echo "Found 300.00"
	       elif grep '400.00' temp.calib
	 	   then
	 	   grep '400.00'  temp.calib >> res.temp
#	 	   grep '400.00'  temp.calib >> Co60.temp      
	 	   echo "Found 400.00"
	 	elif grep '500.00' temp.calib
	 	   then
	 	   grep '500.00'  temp.calib >> res.temp
#	 	   grep '500.00'  temp.calib >> Co60.temp      
	 	   echo "Found 500.00"   
	 	elif grep '600.00' temp.calib
	 	   then
	 	   grep '600.00'  temp.calib >> res.temp
#	 	   grep '600.00'  temp.calib >> Co60.temp      
	 	   echo "Found 600.00"
	 	elif grep '700.00' temp.calib
	 	   then
	 	   grep '700.00'  temp.calib >> res.temp
#	 	   grep '700.00'  temp.calib >> Co60.temp      
	 	   echo "Found 700.00"
	 	elif grep '800.00' temp.calib
	 	   then
	 	   grep '800.00'  temp.calib >> res.temp
#	 	   grep '800.00'  temp.calib >> Co60.temp      
	 	   echo "Found 800.00"
	 	elif grep '900.00' temp.calib
	 	   then
	 	   grep '900.00'  temp.calib >> res.temp
#	 	   grep '900.00'  temp.calib >> Co60.temp      
	 	   echo "Found 900.00"
		elif grep '1000.00' temp.calib
	 	   then
	 	   grep '1000.00'  temp.calib >> res.temp
#	 	   grep '1000.00'  temp.calib >> Co60.temp      
	 	   echo "Found 1000.00"
		elif grep '1100.00' temp.calib
	 	   then
	 	   grep '1100.00'  temp.calib >> res.temp
#	 	   grep '1100.00'  temp.calib >> Co60.temp      
	 	   echo "Found 1100.00"
		elif grep '1200.00' temp.calib
	 	   then
	 	   grep '1200.00'  temp.calib >> res.temp
#	 	   grep '1200.00'  temp.calib >> Co60.temp      
	 	   echo "Found 1200.00"
		elif grep '1300.00' temp.calib
	 	   then
	 	   grep '1300.00'  temp.calib >> res.temp
#	 	   grep '1300.00'  temp.calib >> Co60.temp      
	 	   echo "Found 1300.00"
	 	elif grep '140.0' temp.calib
	 	   then
	 	   grep '140.0'  temp.calib >> res.temp
#	 	   grep '140.0'  temp.calib >> Co60.temp      
	 	   echo "Found 1400."
		elif grep '1500.00' temp.calib
	 	   then
	 	   grep '1500.00'  temp.calib >> res.temp
#	 	   grep '1500.00'  temp.calib >> Co60.temp      
	 	   echo "Found 1500.00"
	 	 elif grep '1600.00' temp.calib
	 	   then
	 	   grep '1600.00'  temp.calib >> res.temp
#	 	   grep '1600.00'  temp.calib >> Co60.temp      
	 	   echo "Found 1600.00"
		 elif grep '1700.00' temp.calib
	 	   then
	 	   grep '1700.00'  temp.calib >> res.temp
#	 	   grep '1700.00'  temp.calib >> Co60.temp      
	 	   echo "Found 1700.00"  
		 elif grep '1800.00' temp.calib
	 	   then
	 	   grep '1800.00'  temp.calib >> res.temp
#	 	   grep '1800.00'  temp.calib >> Co60.temp      
	 	   echo "Found 1800.00"   
	 	 elif grep '1900.00' temp.calib
	 	   then
	 	   grep '1900.00'  temp.calib >> res.temp
#	 	   grep '1900.00'  temp.calib >> Co60.temp      
	 	   echo "Found 1900.00"   
	       elif grep '2000.00' temp.calib
		then
		    grep '2000.00' temp.calib >> res.temp
		    grep '2000.00' temp.calib >> Co60.temp
		    echo "Found 2000.00"
		elif grep '2100.00' temp.calib
		then
		    grep '2100.00' temp.calib >> res.temp
#		    grep '2100.00' temp.calib >> Co60.temp
		    echo "Found 2100.00"
		elif grep '2200.00' temp.calib
		then
		    grep '2200.00' temp.calib >> res.temp
#		    grep '2200.00' temp.calib >> Co60.temp
		    echo "Found 2200.00"
		elif grep '2300.00' temp.calib
		then
		    grep '2300.00' temp.calib >> res.temp
#		    grep '2300.00' temp.calib >> Co60.temp
		    echo "Found 2300.00"
		elif grep '2400.00' temp.calib
		then
		    grep '2400.00' temp.calib >> res.temp
#		    grep '2400.00' temp.calib >> Co60.temp
		    echo "Found 2400.00"
		elif grep '2500.00' temp.calib
		then
		    grep '2500.00' temp.calib >> res.temp
#		    grep '2500.00' temp.calib >> Co60.temp
		    echo "Found 2500.00"
		elif grep '2600.00' temp.calib
		then
		    grep '2600.00' temp.calib >> res.temp
#		    grep '2600.00' temp.calib >> Co60.temp
		    echo "Found 2600.00"
		elif grep '2700.00' temp.calib
		then
		    grep '2700.00' temp.calib >> res.temp
#		    grep '2700.00' temp.calib >> Co60.temp
		    echo "Found 2700.00"
		elif grep '2800.00' temp.calib
		then
		    grep '2800.00' temp.calib >> res.temp
#		    grep '2800.00' temp.calib >> Co60.temp
		    echo "Found 2800.00"
		elif grep '2900.00' temp.calib
		then
		    grep '2900.00' temp.calib >> res.temp
#		    grep '2900.00' temp.calib >> Co60.temp
		    echo "Found 2900.00"
		elif grep '3000.00' temp.calib
		then
		    grep '3000.00' temp.calib >> res.temp
		    echo "Found 3000.00"
		elif grep '3100.00' temp.calib
		then
		    grep '3100.00' temp.calib >> res.temp
#		    grep '3100.00' temp.calib >> Co60.temp
		    echo "Found 3100.00"
		elif grep '3200.00' temp.calib
		then
		    grep '3200.00' temp.calib >> res.temp
#		    grep '3200.00' temp.calib >> Co60.temp
		    echo "Found 3200.00"
		elif grep '3300.00' temp.calib
		then
		    grep '3300.00' temp.calib >> res.temp
#		    grep '3300.00' temp.calib >> Co60.temp
		    echo "Found 3300.00"
		elif grep '3400.00' temp.calib
		then
		    grep '3400.00' temp.calib >> res.temp
#		    grep '3400.00' temp.calib >> Co60.temp
		    echo "Found 3400.00"
		elif grep '3500.00' temp.calib
		then
		    grep '3500.00' temp.calib >> res.temp
		    echo "Found 3500.00"
		elif grep '3600.00' temp.calib
		then
		    grep '3600.00' temp.calib >> res.temp
#		    grep '3600.00' temp.calib >> Co60.temp
		    echo "Found 3600.00"
		elif grep '3700.00' temp.calib
		then
		    grep '3700.00' temp.calib >> res.temp
#		    grep '3700.00' temp.calib >> Co60.temp
		    echo "Found 3700.00"
		elif grep '3800.00' temp.calib
		then
		    grep '3800.00' temp.calib >> res.temp
#		    grep '3800.00' temp.calib >> Co60.temp
		    echo "Found 3800.00"
		elif grep '3900.00' temp.calib
		then
		    grep '3900.00' temp.calib >> res.temp
#		    grep '3900.00' temp.calib >> Co60.temp
		    echo "Found 3900.00"
		elif grep '4000.00' temp.calib
		then
		    grep '4000.00' temp.calib >> res.temp
		    echo "Found 4000.00"

		 	else
		 	   echo "modify script add energy" 
			fi	
		fi  
	  
		sed "1 s/./Fold $foldnbr\t&/" res.temp >res1.temp

		cat data.calib res1.temp >> data.calib
		sed -i "s/#2/$foldnbr/" data.calib
		#sed -i "s/#2/$foldnbr/" Co60.temp

		 rm res.temp
		 rm res1.temp
		# rm temp.calib
 		 echo -ne ""; tput setaf 2; echo "Finished for Energy $energy Fold $foldnbr";tput sgr0;	
		 foldnbr=$(($foldnbr + 1))
	done 



	fold_file=fold_data_run_"$run"_"$energy".txt

	#awk -F " " '{ print $3 " " $6 " " $7 " " $11 " " $8 " " $9 " " $9/$8*$11 " keV" }' data.calib > resolution.txt 

	#awk -F " " '{ print $3 " " $6 " " $7 " " $11 " " $8 " " $9 " " $9/$8*$11 " [keV]; eff [%]: " $7/'$activityCo60'*100}' Co60.temp > fold_data.txt
	awk -F " " '{ print $2 " " $5 " " $8 " " $9 " " $13 " " $10 " " $11 " " $8 " [keV]; eff [%]: " $10/'$activity'*100 " " '$activity'}' data.calib > $fold_file
	#$2 - Fold;  $8 - resolution $10 -Area;  #may be I do not need the other fileds but it is read further from position
	
#	Fold 1	     0      0    1   1   1800.00    3.146    5.735     19522   1800.01    3.1    5822   1.823   1.823    0.999995   0.00


	divisor=$(awk 'NR==1 {print $6}' $fold_file) #fold1
	errdivisor=$(awk "BEGIN {print sqrt($divisor)}")
	errdivisor=$(awk "BEGIN {print 1 / $errdivisor}")

	echo 'divisor' $divisor 'err' $errdivisor


	echo "Energy "$energy
	#awk -v divisor="$divisor" '{print $1, $6 / divisor}' fold_data.txt
	awk -v divisor="$divisor" '{printf "%s %s ", $1, $6 / divisor}' $fold_file
	echo ""

	echo -n "Energy "$energy" " > add_back_run_"$run"_"$energy".txt
	#awk -v divisor="$divisor" '{printf "%s %s ", $1, $6 / divisor}' fold_data.txt >> add_back_$energy.txt
	awk -v divisor="$divisor" '{printf "%s %s %s", $1, $6 / divisor, (1 / sqrt($6) + errdivisor) }' $fold_file >> add_back_run_"$run"_"$energy".txt

	#tried to print errors
	#awk -v divisor="$divisor" -v errdivisor="$errdivisor" '{
	#    printf "%s %s %s\n", $1, $6 / divisor, (1 / sqrt($6) + errdivisor)
	#}' fold_data.txt >> add_back_$energy.txt


	echo -n "Energy "$energy" " >> add_back_all_run_"$run".txt
	awk -v divisor="$divisor" '{printf "%s %s %s %s ", $1, $6, divisor, $6 / divisor}' $fold_file >> add_back_all_run_"$run".txt
	
	echo "" >> add_back_all_run_"$run".txt
	#tried to print errors
	#awk -v divisor="$divisor" -v errdivisor="$errdivisor" '{
	#    printf "%s %s %s\n", $1, $6 / divisor, (1 / sqrt($6) + errdivisor)
	#}' fold_data.txt >>  add_back_all_run$run.txt
#	echo "FINISHED for " >> add_back_all_run$run.txt

#	rm data.calib

        tput setaf 2; echo "FINISHED for $energy";tput sgr0;
		


	energy=$(($energy + 100))
done


dir_name=run_"$run"

if [ ! -d "$dir_name" ]; then
  # If the directory does not exist, create it
  mkdir "$dir_name"
  echo "Directory '$dir_name' created."
else
  echo "Directory '$dir_name' already exists."
fi

mv  *_run_"$run"*.txt $dir_name




