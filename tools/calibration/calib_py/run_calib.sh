#!/bin/bash

#echo "first domain; last domain; activities: activityCo137; activityCo60; activityNa22; activityEu152 "
echo "Hello I run_calib.sh, I am controlled by python"


FIRSTdomain=$1
LASTdomain=${2:-$1}
activityCs137=${3:-0}
activityCo60=${4:-0}
activityNa22=${5:-0}
activityEu152=${6:-0}


CUR_DIR=$(pwd)
cd $CUR_DIR

echo "CUR_DIR $CUR_DIR"

domnb=$FIRSTdomain
echo "file: ../mDelila_raw_py_$domnb.spe"
 if test -f "../mDelila_raw_py_$domnb.spe"
   then
   echo "file found"
   else
   echo "no spectrum file"
 fi

echo "Will run the calib for domains $FIRSTdomain upto $LASTdomain "


##################################   
#check awk version
##################################   
echo "Checking awk version"
mawk=0
awk -W version > awkversion.tmp
if grep 'mawk' awkversion.tmp
then
  mawk=1
  echo "awk version is MAWK, mawk parameter for calculation is enabled $mawk"
fi 	
rm awkversion.tmp

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
    if test -f "152Eu.temp" 
   then 
   	rm "152Eu.temp"
   fi   
##################################      
    if test -f "temp.calib" 
   then 
   	rm "temp.calib"   
   fi
##################################
#    if test -f "resolution.txt" 
#   then 
#   	rm "resolution.txt"   
#   fi
##################################
    if test -f "fulldata.calib" 
   then 
   	rm "fulldata.calib"   
   fi
################################## 
#rm resolution_dom_*.txt
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

if [[ "$activityEu152" -gt "0" ]];
 then
  source="$source -152Eu"
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
 id=$(($id%10)) 
# lim1=2000 lim2=5000 fwhm=4 ampl=100 #60Co
# lim1=1200 lim2=4500 fwhm=7 ampl=100
 lim1=700 lim2=2000 fwhm=7 ampl=100
 case "$id" in
#"9")  lim1=1000  lim2=5000 fwhm=4  ampl=100 ;;
"9")  lim1=800  lim2=1600 fwhm=4  ampl=100 ;;
#"0") lim1=1000 lim2=2000 fwhm=4  ampl=10s00 ;;
"0") lim1=200 lim2=600 fwhm=4  ampl=10s00 ;;
*) echo "$id - default" ;;
esac
echo "settings for xx-id $id : limits: $lim1 $lim2 fwhm: $fwhm $ampl"

 if test -f "../mDelila_raw_py_$domnb.spe"
   then
      ~/EliadeSorting/EliadeTools/RecalEnergy -spe ../mDelila_raw_py_$domnb.spe -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl $source -v 2 -poly1
      ~/EliadeSorting/EliadeTools/RecalEnergy -spe ../mDelila_raw_py_$domnb.spe -fmt A 16384 -lim $lim1 $lim2 -dwa $fwhm $ampl $source -v 2 -poly1 > fulldata.calib
      #delete first 14 lines
      awk 'NR > 14 { print }' fulldata.calib >  temp.calib
      #delete 20 first lines if the source is 152Eu	
      if [[ "$activityEu152" -gt "0" ]];
      then
       awk 'NR > 20 { print }' fulldata.calib >  temp.calib
      fi      

      echo -n "domain $domnb " >> eliade.calib      
      if grep 'Cal1' temp.calib
	then
 	   grep 'Cal1'  temp.calib >> eliade.calib      
 	   echo "Found Cal1"
 	else echo " ">> eliade.calib #if domain is emtry add a new line
	fi 	
	
 	if [[ "$mawk" -eq "1" ]]
        then      
	   rm tempmawk.calib
	   sed 's/\./,/g' temp.calib > tempmawk.calib
	   mv tempmawk.calib temp.calib
	 fi
	
	####################22Na####################
 	if grep '511.006' temp.calib
	then
           #echo -n "domain $domnb " >> Co60.calib    
 	  #grep '511.006'  temp.calib >> Co60.calib
 	   grep '511.006'  temp.calib >> res.temp
# 	   grep '511.006'  temp.calib >> Na22.temp      
 	   echo "Found 511.006"
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
	####################137Cs####################
	if grep '661.661' temp.calib
	then
           #echo -n "domain $domnb " >> Co60.calib    
 	   grep '661.661'  temp.calib >> res.temp
 	   grep '661.661'  temp.calib >> Cs137.temp
 	   sed -i "s/#2/$domnb/" Cs137.temp     
 	   echo "Found 661.661"
	fi
	####################60Co####################
	if grep '1173.238' temp.calib
	then
           #echo -n "domain $domnb " >> Co60.calib    
 	   grep '1173.238'  temp.calib >> res.temp
 	   grep '1173.238'  temp.calib >> Co60.temp
	   sed -i "s/#2/$domnb/" Co60.temp
 	   echo "Found 1173.238"
	fi
	if grep '1332.513' temp.calib    
	then
 	   grep '1332.513'  temp.calib >> res.temp
 	   grep '1332.513'  temp.calib >> Co60.temp
 	   sed -i "s/#2/$domnb/" Co60.temp
 	   echo "Found"
	fi
	####################40K####################
	if grep '1460.81' temp.calib	    
	then
 	   grep '1460.81'  temp.calib >> res.temp
 	   echo "Found"
	fi
	####################152Eu####################
	if grep '121.779' temp.calib
	then
           #echo -n "domain $domnb " >> 152Eu.calib    
 	  #grep '121.779'  temp.calib >> 152Eu.calib
 	   grep '121.779'  temp.calib >> res.temp
 	   grep '121.779'  temp.calib >> 152Eu.temp
 	   sed -i "s/#2/$domnb/" 152Eu.temp 
 	   echo "Found 121.779"
	fi
	##################################     
	if grep '244.693' temp.calib	    
	then
           #echo -n "domain $domnb " >> 152Eu.calib 
 	   grep '244.693'  temp.calib >> res.temp
 	   grep '244.693'  temp.calib >> 152Eu.temp      
 	   sed -i "s/#2/$domnb/" 152Eu.temp  	   
 	   echo "Found"
	fi
	##################################
	if grep '344.272' temp.calib	    
	then
           #echo -n "domain $domnb " >> 152Eu.calib 
 	   grep '344.272'  temp.calib >> res.temp
 	   grep '344.272'  temp.calib >> 152Eu.temp      
 	   sed -i "s/#2/$domnb/" 152Eu.temp  	   
 	   echo "Found"
	fi
	##################################     
	if grep '411.111' temp.calib	    
	then
           #echo -n "domain $domnb " >> 152Eu.calib 
 	   grep '411.111'  temp.calib >> res.temp
 	   grep '411.111'  temp.calib >> 152Eu.temp      
 	   sed -i "s/#2/$domnb/" 152Eu.temp  	   
 	   echo "Found"
	fi
	##################################     
	if grep '443.979' temp.calib	    
	then
           #echo -n "domain $domnb " >> 152Eu.calib 
 	   grep '443.979'  temp.calib >> res.temp
 	   grep '443.979'  temp.calib >> 152Eu.temp      
 	   sed -i "s/#2/$domnb/" 152Eu.temp 
 	   echo "Found"
	fi
	##################################     
	if grep '778.890' temp.calib	    
	then
           #echo -n "domain $domnb " >> 152Eu.calib 
 	   grep '778.890'  temp.calib >> res.temp
 	   grep '778.890'  temp.calib >> 152Eu.temp      
 	   sed -i "s/#2/$domnb/" 152Eu.temp 
 	   echo "Found"
	fi
	##################################     
	if grep '964.014' temp.calib	    
	then
           #echo -n "domain $domnb " >> 152Eu.calib 
 	   grep '964.014'  temp.calib >> res.temp
 	   grep '964.014'  temp.calib >> 152Eu.temp      
 	   sed -i "s/#2/$domnb/" 152Eu.temp 
 	   echo "Found"
	fi
	##################################     
	if grep '1085.793' temp.calib	    
	then
           #echo -n "domain $domnb " >> 152Eu.calib 
 	   grep '1085.793'  temp.calib >> res.temp
 	   grep '1085.793'  temp.calib >> 152Eu.temp      
 	   sed -i "s/#2/$domnb/" 152Eu.temp 
 	   echo "Found"
	fi
	##################################     
	if grep '1112.070' temp.calib	    
	then
           #echo -n "domain $domnb " >> 152Eu.calib 
 	   grep '1112.070'  temp.calib >> res.temp
 	   grep '1112.070'  temp.calib >> 152Eu.temp      
 	   sed -i "s/#2/$domnb/" 152Eu.temp 
 	   echo "Found"
	fi
	##################################     
	if grep '1407.993' temp.calib	    
	then
           #echo -n "domain $domnb " >> 152Eu.calib 
 	   grep '1407.993'  temp.calib >> res.temp
 	   grep '1407.993'  temp.calib >> 152Eu.temp      
 	   sed -i "s/#2/$domnb/" 152Eu.temp 
 	   echo "Found"
	fi
	##################################          	

	
	if grep '#2' res.temp
	then
 	   grep '#2'  res.temp >> data.calib      
 	   echo "Found"
	fi            
   else 
     echo no file "../mDelila_raw_py_$domnb.spe"
     echo "domain $domnb #2     0  Slope = 0.000000    Cal1=[ -0.0000  1.000000 ]" >> eliade.calib       
     #echo "#2" >> eliade.calib 
     #sed -i "s/#2/$domnb/" eliade.calib
   fi  

  sed -i "s/#2/$domnb/" data.calib


 rm res.temp
 rm newtemp.calib	
 domnb=$(($domnb + 1))
done 
 
cat eliade.calib | sed 's/|/ /' | awk '{print $2, $9, $10}' >  eliade.coeff

if [[ "$activityCs137" -gt "0" ]];
 then
 rm resolution_661.txt
 awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/'$activityCs137'*100*0,851}' Cs137.temp > temp1.txt
 grep '661.661' temp1.txt >> resolution_661.txt
 grep '661.661' temp1.txt > resolution137Cs.txt
 gnuplot -e "ENER=661" gnuplot/res_eliade_ener.p
 rm temp1.txt
fi
 
if [[ "$activityCo60" -gt "0" ]];
 then 

  rm resolution_1332.txt
  rm resolution_1173.txt  
  awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/'$activityCo60'*100*0.99}' Co60.temp > temp1.txt
  grep '1332.513' temp1.txt >> resolution_1332.txt
  grep '1173.238' temp1.txt >> resolution_1173.txt
  grep '1332.513' temp1.txt > resolutionCo60.txt
  grep '1173.238' temp1.txt >> resolutionCo60.txt
  
  
  #gnuplot does not like ","
  if [[ "$mawk" -eq "1" ]]
  then
 	  if test -f "newres.txt" 
	   then 
   		rm "newres.txt"   
	  fi  
	  sed 's/,/\./g' resolution_1332.txt > newres.txt
	  mv newres.txt resolution_1332.txt
	  sed 's/,/\./g' resolution_1173.txt > newres.txt
	  mv newres.txt resolution_1173.txt
	  sed 's/,/\./g' resolutionCo60.txt > newres.txt
	  mv newres.txt resolutionCo60.txt
  fi
  
  
    gnuplot -e "ENER=1332" gnuplot/res_eliade_ener.p
    gnuplot -e "ENER=1173" gnuplot/res_eliade_ener.p
  rm temp1.txt
fi

if [[ "$activityEu152" -gt "0" ]];
 then
  rm resolution_121.txt
  rm resolution_244.txt
  rm resolution_344.txt
  rm resolution_411.txt
  rm resolution_444.txt
  rm resolution_778.txt
  rm resolution_964.txt
  rm resolution_1085.txt
  rm resolution_1112.txt
  rm resolution_1408.txt 

 grep "121.779" 152Eu.temp | awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/1*100*0.2858}' > resolution_121.txt
 grep "244.693" 152Eu.temp | awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/1*100*0.7583 }' > resolution_244.txt
 grep "344.272" 152Eu.temp | awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/1*100*0.265}' > resolution_344.txt
 grep "411.111" 152Eu.temp | awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/1*100*0.02234}' > resolution_411.txt
 grep "443.979" 152Eu.temp | awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/1*100*0.3148}' > resolution_444.txt
 grep "778.890" 152Eu.temp | awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/1*100*0.12942}' > resolution_778.txt
 grep "964.014" 152Eu.temp | awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/1*100*0.14605}' > resolution_964.txt
 grep "1085.793" 152Eu.temp | awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/1*100*0.10207}' > resolution_1085.txt
 grep "1112.070" 152Eu.temp | awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/1*100*0.13644}' > resolution_1112.txt
 grep "1407.993" 152Eu.temp | awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/1*100*0.21005}' > resolution_1408.txt

 less resolution_121.txt > resolutionEu152.txt
 less resolution_244.txt >> resolutionEu152.txt 
 less resolution_344.txt >> resolutionEu152.txt
 less resolution_411.txt >> resolutionEu152.txt
 less resolution_444.txt >> resolutionEu152.txt
 less resolution_778.txt >> resolutionEu152.txt
 less resolution_964.txt >> resolutionEu152.txt
 less resolution_1085.txt >> resolutionEu152.txt
 less resolution_1112.txt >> resolutionEu152.txt
 less resolution_1408.txt >> resolutionEu152.txt

  gnuplot -e "ENER=121" gnuplot/res_eliade_ener.p
  gnuplot -e "ENER=244" gnuplot/res_eliade_ener.p
  gnuplot -e "ENER=344" gnuplot/res_eliade_ener.p
  gnuplot -e "ENER=411" gnuplot/res_eliade_ener.p
  gnuplot -e "ENER=444" gnuplot/res_eliade_ener.p
  gnuplot -e "ENER=778" gnuplot/res_eliade_ener.p
  gnuplot -e "ENER=964" gnuplot/res_eliade_ener.p
  gnuplot -e "ENER=1085" gnuplot/res_eliade_ener.p
  gnuplot -e "ENER=1112" gnuplot/res_eliade_ener.p
  gnuplot -e "ENER=1408" gnuplot/res_eliade_ener.p
    
#  rm temp1.txt
fi

if [[ "$activityNa22" -gt "0" ]];
 then
  rm resolution_1274.txt
  awk -F " " '{ print $1 " " $5 " " $9 " " $6 " " $7 " " $7/$6*$9 " [keV]; eff [%]: " $5/'$activityNa22'*100*0.99944}' Na22.temp > temp1.txt
#  grep '511.006' temp1.txt >> resolution_511.txt
  grep '1274.545' temp1.txt >> resolution_1274.txt
#  grep '511.006' temp1.txt >> resolutionNa22.txt
  grep '1274.545' temp1.txt >> resolutionNa22.txt
  gnuplot -e "ENER=1274" res_eliade_ener.p
  rm temp1.txt
fi

  gnuplot gnuplot/res_eliade.p
  gnuplot gnuplot/eff_eliade.p

rm Co60.temp
rm Cs137.temp
rm Na22.temp
rm 152Eu.temp
rm data.calib


echo "Resolution for each domain"
domnb=$FIRSTdomain
while test $domnb -le $LASTdomain
do
 rm resolution_dom_$domnb.txt
 if grep "$domnb " resolutionEu152.txt
 then
  grep "$domnb " resolutionEu152.txt >> resolution_dom_$domnb.txt
  gnuplot -e "DOM=$domnb" gnuplot/res_eliade_dom.p
  gnuplot -e "DOM=$domnb" gnuplot/eff_eliade_dom.p
 fi 

 if grep "$domnb " resolutionCo60.txt
 then
  grep "$domnb " resolutionCo60.txt >> resolution_dom_$domnb.txt
  gnuplot -e "DOM=$domnb" gnuplot/res_eliade_dom.p
  gnuplot -e "DOM=$domnb" gnuplot/eff_eliade_dom.p
 fi 
 
 if grep "$domnb " resolutionCs137.txt
 then
  grep "$domnb " resolutionCs137.txt >> resolution_dom_$domnb.txt
  gnuplot -e "DOM=$domnb" gnuplot/res_eliade_dom.p
  gnuplot -e "DOM=$domnb" gnuplot/eff_eliade_dom.p
 fi  
 
 if grep "$domnb " resolutionNa22.txt
 then
  grep "$domnb " resolutionNa22.txt >> resolution_dom_$domnb.txt
  gnuplot -e "DOM=$domnb" gnuplot/res_eliade_dom.p
  gnuplot -e "DOM=$domnb" gnuplot/eff_eliade_dom.p
 fi 
 
 domnb=$(($domnb + 1))
done

mkdir -p eps
mv *.eps eps

