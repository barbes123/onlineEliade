#include <iostream>
#include <fstream>
#include <string>
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TF1.h"
#include "TCanvas.h"
#include "TString.h"
void GetMultiplicity(TH1 *hh, int nn_max = 15)
{

  std::cout << "Welcome to the automatic GetMultiplicity macro \n"
	    << "I will calculate Multiplicity ratios from the analyszed file\n"
	    << "and will put it in the file"
	    << std::endl;
  fstream outputFile;
  outputFile.open("multiplicity.dat", ios_base::out);
  int mult[nn_max];
  
  for (int i = 1; i<=nn_max; i++)mult[i]=-1;  
  
  for (int i = 1; i<=nn_max; i++){
    mult[i-1] = hh->GetBinContent(i);  
    std::cout<< i-1 <<" "<<mult[i-1]<<"\n";
    outputFile<< i-1 <<" "<<mult[i-1]<<"\n";    
  };
  
  int nn_tot = 0;
  for (int i = 1; i<=nn_max; i++) nn_tot+=i*mult[i];  
  
//   for (int i = 1; i<=nn_max; i++)   std::cout	<<i<<" ddd "<< mult[i] <<"\n";



  std::cout	<<" N1/N2 " <<mult[1]*1.0/mult[2]
    		<<"\n N1/N3 " <<mult[1]*1.0/mult[3]
    		<<"\n N2/N3 " <<mult[2]*1.0/mult[3]
    		<<"\n N2/N4 " <<mult[2]*1.0/mult[4]
    		<<"\n N3/N4 " <<mult[3]*1.0/mult[4]
    		    		
    		<<"\n N2/N5 " <<mult[2]*1.0/mult[5]
    		<<"\n N3/N5 " <<mult[3]*1.0/mult[5]
    		<<"\n N4/N5 " <<mult[5]*1.0/mult[5]
		<<"\n TOT   " << nn_tot <<"\n";
    		
    
  outputFile	<<" N1/N2 " <<mult[1]*1.0/mult[2]
    		<<"\n N1/N3 " <<mult[1]*1.0/mult[3]
    		<<"\n N2/N3 " <<mult[2]*1.0/mult[3]
    		<<"\n N2/N4 " <<mult[2]*1.0/mult[4]
    		<<"\n N3/N4 " <<mult[3]*1.0/mult[4]
    		    		
    		<<"\n N2/N5 " <<mult[2]*1.0/mult[5]
    		<<"\n N3/N5 " <<mult[3]*1.0/mult[5]
    		<<"\n N4/N5 " <<mult[4]*1.0/mult[5]
		<<"\n TOT   " << nn_tot <<"\n";
  
  outputFile.close();
}
