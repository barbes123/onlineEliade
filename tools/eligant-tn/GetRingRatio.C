#include <iostream>
#include <fstream>
#include <string>
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TF1.h"
#include "TCanvas.h"
#include "TString.h"
void GetRingRatio(TH1 *hh, int r_max = 3)
{

  std::cout << "Welcome to the automatic GetRingRatio macro \n"
	    << "I will calculate Multiplicity ratios from the analyszed file\n"
	    << "and will put it in the file"
	    << std::endl;
        
  fstream outputFile;
  
  outputFile.open("ring_ratio.dat", ios_base::out);
  
  int nnring[r_max];
  int nn_tot = 0;
  for (int i = 1; i<=r_max; i++)nnring[i]=-1;  
  
  for (int i = 1; i<=r_max; i++){
    nnring[i] = hh->GetBinContent(i);  
    nn_tot+=nnring[i];
    std::cout<< i <<" "<<nnring[i]<<"\n";
    outputFile<< i <<" "<<nnring[i]<<"\n";    
  };
  


  std::cout	<<" R1/R2 " << nnring[1]*1.0/nnring[2]
    		<<"\n R1/R3 " <<nnring[1]*1.0/nnring[3]
    		<<"\n R2/R3 " <<nnring[2]*1.0/nnring[3]
            <<"\n TOT   " << nn_tot <<"\n";
    		
    
  outputFile <<" R1/R2 " <<nnring[1]*1.0/nnring[2]
    		<<"\n R1/R3 " <<nnring[1]*1.0/nnring[3]
    		<<"\n R2/R3 " <<nnring[2]*1.0/nnring[3]
            <<"\n TOT   " << nn_tot <<"\n";
  
  outputFile.close();
}
