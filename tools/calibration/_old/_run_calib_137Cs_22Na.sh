#!/bin/bash

echo "first domain; last domain; activities: activityCo137; activityCo60; activityNa22 "

FIRSTdomain=$1
LASTdomain=${2:-$1}
activityCs137=${3:-0}
activityCo60=${4:-0}
activityNa22=${5:-0}
#$activityCs137=$3


CUR_DIR=$(pwd)
cd $CUR_DIR

echo "CUR_DIR $CUR_DIR"


domnb=$FIRSTdomain
echo "mDelila_raw_py_$domnb.spe" 
 if test -f "mDelila_raw_py_$domnb.spe" 
   then
   echo "file found"
   else
   echo "nooooooooooooooooo"
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
    if test -f "Cs137.temp" 
   then 
   	rm "Cs137.temp"   
   fi   
##################################      
    if test -f "Na22.temp" 
   then 
   	rm "Na22.temp"   
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
k40=0
source=""

if [[ "$activityCs137" -gt "0" ]];
 then
  source="$source -137Cs"
fi
 
if [[ "$activityCo60" -gt "0" ]];
 then
  source="$source -60Co"
fi

if [[ "$activityNa22" -gt "0" ]];
 then
  source="$source -22Na"
fi
 
if [[ "$k40" -eq "1" ]];
 then
  source="$source -40K"
fi 

echo "Validated sources: $source"
      
#lim1=1000 lim2=4000 fwhm=4 ampl=100

domnb=$FIRSTdomain
while test $domnb -le $LASTdomain
do
 echo "Now starting calib for domain $domnb"
 
 #get id
 id=$(($domnb%100)) 
# echo "$id"
 id=$(($id%10)) 
# if [[ "$id" -gt "10" ]];
# then
#  id=$(($id%10)) 
# fi
#  echo "$id"
# exit
 lim1=2000 lim2=5000 fwhm=4 ampl=100
 case "$id" in
"9")  lim1=1000  lim2=5000 fwhm=4  ampl=100 ;;
"0") lim1=1000 lim2=2000 fwhm=4  ampl=1000 ;;
*) echo "$id - default" ;;
esac
echo "settings for $id : limits: $lim1 $lim2 fwhm: $fwhm $ampl" 

 if test -f "mDelila_raw_py_$domnb.spe" 
   then
      #get full data on calibration
      #/data/live/IT/tools/RecalEnergy -spe mDelila_raw_py_$domnb.spe -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl -60Co -v 2 -poly1 -ener 1460.82
      #/data/live/IT/tools/RecalEnergy -spe mDelila_raw_py_$domnb.spe -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl -60Co -v 2 -poly1 -ener 1460.82 > fulldata.calib
      ~/EliadeSorting/EliadeTools/RecalEnergy -spe mDelila_raw_py_$domnb.spe -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl $source -v 2 -poly1
      ~/EliadeSorting/EliadeTools/RecalEnergy -spe mDelila_raw_py_$domnb.spe -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl $source -v 2 -poly1 > fulldata.calib
      #delete first 14 lines
      awk 'NR > 14 { print }' fulldata.calib >  temp.calib
      
      echo -n "domain $domnb " >> eliade.calib      
      if grep 'Cal1' temp.calib
	then
 	   grep 'Cal1'  temp.calib >> eliade.calib      
 	   echo "Found Cal1"
 	else echo " ">> eliade.calib #if domain is emtry add a new line
	fi 	
	##################################   
 	if grep '511.006' temp.calib
	then
           #echo -n "domain $domnb " >> Co60.calib    
 	  #grep '511.006'  temp.calib >> Co60.calib
 	   grep '511.006'  temp.calib >> res.temp
# 	   grep '511.006'  temp.calib >> Na22.temp      
 	   echo "Found 511.006"
	fi   
	if grep '661.661' temp.calib
	then
           #echo -n "domain $domnb " >> Co60.calib    
 	  #grep '661.661'  temp.calib >> Co60.calib
 	   grep '661.661'  temp.calib >> res.temp
 	   grep '661.661'  temp.calib >> Cs137.temp
 	   sed -i "s/#2/$domnb/" Cs137.temp     
 	   echo "Found 661.661"
	fi
	if grep '1173.238' temp.calib
	then
           #echo -n "domain $domnb " >> Co60.calib    
 	  #grep '1173.238'  temp.calib >> Co60.calib
 	   grep '1173.238'  temp.calib >> res.temp
 	   grep '1173.238'  temp.calib >> Co60.temp
	   sed -i "s/#2/$domnb/" Co60.temp
 	   echo "Found 1173.238"
	fi
	if grep '1332.513' temp.calib	    
	then
           #echo -n "domain $domnb " >> Co60.calib 
 	   grep '1332.513'  temp.calib >> res.temp
 	   grep '1332.513'  temp.calib >> Co60.temp
 	   sed -i "s/#2/$domnb/" Co60.temp
 	   echo "Found"
	fi
	if grep '1274.545' temp.calib
	then
           #echo -n "domain $domnb " >> Co60.calib    
 	  #grep '1274.545'  temp.calib >> Co60.calib
 	   grep '1274.545'  temp.calib >> res.temp
 	   grep '1274.545'  temp.calib >> Na22.temp
 	   sed -i "s/#2/$domnb/" Na22.temp
 	   echo "Found 1274.545"
	fi
	if grep '1460.81' temp.calib	    
	then
           #echo -n "domain $domnb " >> Co60.calib 
 	   grep '1460.81'  temp.calib >> res.temp      
 	   echo "Found"
	fi
	if grep '#2' res.temp
	then
 	   grep '#2'  res.temp >> data.calib      
 	   echo "Found"
	fi            
   else 
     echo no file "mDelila_raw_py_$domnb.spe" 
     echo "domain $domnb #2     0  Slope = 0.000000    Cal1=[ -0.0000  1.000000 ]" >> eliade.calib       
     #echo "#2" >> eliade.calib 
     #sed -i "s/#2/$domnb/" eliade.calib
   fi  

  sed -i "s/#2/$domnb/" data.calib


 rm res.temp
 rm temp.calib	
 domnb=$(($domnb + 1))
done 
 
cat eliade.calib | sed 's/|/ /' | awk '{print $2, $9, $10}' >  eliade.coeff

#awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " keV" }' data.calib > resolution.txt 
#awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/'$activityCo60'*100}' Co60.temp > eff_60Co.txt

#awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/'$activityCo60'*100}' data.calib > resolution.txt 



if [[ "$activityCs137" -gt "0" ]];
 then 
 rm resolution_661.txt
 awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/'$activityCs137'*100*0.851}' Cs137.temp > temp1.txt
 grep '661.661' temp1.txt >> resolution_661.txt
 grep '661.661' temp1.txt >> resolution.txt
 gnuplot -e "ENER=661" res_eliade_ener.p
 rm temp1.txt
fi
 
if [[ "$activityCo60" -gt "0" ]];
 then
  rm resolution_1332.txt
  rm resolution_1173.txt  
  awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/'$activityCo60'*100*0.99}' Co60.temp > temp1.txt
  grep '1332.513' temp1.txt >> resolution_1332.txt
  grep '1173.238' temp1.txt >> resolution_1173.txt
  grep '1332.513' temp1.txt >> resolution.txt
  grep '1173.238' temp1.txt >> resolution.txt
    gnuplot -e "ENER=1332" res_eliade_ener.p
    gnuplot -e "ENER=1173" res_eliade_ener.p
  rm temp1.txt
fi

if [[ "$activityNa22" -gt "0" ]];
 then
  rm resolution_1274.txt
  awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/'$activityNa22'*100*0.99944}' Na22.temp > temp1.txt
#  grep '511.006' temp1.txt >> resolution_511.txt
  grep '1274.545' temp1.txt >> resolution_1274.txt
#  grep '511.006' temp1.txt >> resolution.txt
  grep '1274.545' temp1.txt >> resolution.txt
  gnuplot -e "ENER=1274" res_eliade_ener.p
  rm temp1.txt
fi

  gnuplot res_eliade.p
  gnuplot eff_eliade.p

rm Co60.temp
rm Cs137.temp
rm Na22.temp
rm data.calib


echo "Resolution for each domain"
domnb=$FIRSTdomain
while test $domnb -le $LASTdomain
do

 if grep "$domnb " resolution.txt
 then
  echo "eps plots for dom: $domnb"
  grep "$domnb " resolution.txt > resolution_dom_$domnb.txt
  gnuplot -e "DOM=$domnb" res_eliade_dom.p
  gnuplot -e "DOM=$domnb" eff_eliade_dom.p
 fi 
 domnb=$(($domnb + 1))
done

mkdir -p eps
mv *.eps eps



#grep '1173.238' resolution.txt >> resolution_1173.txt
#grep '1173.238' resolution.txt >> resolution_1173.txt

