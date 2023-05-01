#include <iostream>
#include <fstream>
#include <string>
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TCanvas.h"
#include "TString.h"
#include <map>
#include <TSystem.h>

// void GetMatrixInt(TH2 *matrix)
void GetRingRatioApril(int run_start = 44, int run_stop = 44)
{

  std::cout << "Welcome to the automatic GetMatrixInt macro \n"
	    << "I will calculate statistics from a projection of the matrix provided  \n"
	    << std::endl;
        
//  int run = run_start;
 
 TFile *fin;
 int r_max = 4;
 int vernb = 999; //version id for summed runs

 for (int runnb = run_start; runnb<=run_stop; runnb++){
     if(gSystem->AccessPathName(Form("selected_run_%i_%i_eliadeS2.root", run_start, vernb))){
        std::cout << "File run "<< run_start <<" does not exist" << std::endl;
        continue;
     };
    
    fin = new TFile (Form("selected_run_%i_%i_eliadeS2.root", runnb, vernb),"read"); 
    
    TH1F *hh =  (TH1F*) fin->Get("Neutron/hNN_ring");
    int nnring[r_max];
    int nn_tot = 0;
    for (int i = 1; i<=r_max; i++)nnring[i]=-1;  
  
    for (int i = 1; i<=r_max; i++){
     nnring[i] = hh->GetBinContent(i);  
     nn_tot+=nnring[i];
    // std::cout<< i <<" "<<nnring[i]<<"\n";
    };

    std::cout<<"run "<<runnb<<" R1/R2 " << nnring[1]*1.0/nnring[2]<<" R1/R3 " <<nnring[1]*1.0/nnring[3]<<" R2/R3 " <<nnring[2]*1.0/nnring[3] <<" TOT   " << nn_tot <<"\n";
    //std::cout<<" R1 " << nnring[1]<<" R2 " <<nnring[2]<<" R3 " <<nnring[3] <<" TOT   " << nn_tot <<"\n";


 };
}
