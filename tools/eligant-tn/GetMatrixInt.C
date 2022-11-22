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
void GetMatrixInt(TString mName, int run_start = 0, int run_stop = 0)
{

  std::cout << "Welcome to the automatic GetMatrixInt macro \n"
	    << "I will calculate statistics in the matrix provided  \n"
	    << std::endl;
        
//  int run = run_start;
 
 TFile *fin;
        
//  TFile *fin = new TFile(Form("selected_run_%i_%i_eliadeS2.root", run, 0),"read"); 
 for (int run = run_start; run<= run_stop; run++){
     
     if(gSystem->AccessPathName(Form("selected_run_%i_%i_eliadeS2.root", run, 0))){
        std::cout << "File run "<< run <<" does not exist" << std::endl;
        continue;
    };
    
    fin = new TFile (Form("selected_run_%i_%i_eliadeS2.root", run, 0),"read"); 
    
    TH2F *matrix =  (TH2F*) fin->Get(mName);
    int sumInt = matrix -> GetEntries();
    std::cout<<" run "<< run<<" counts " << sumInt <<"\n";
    fin->Close();
    }
}
