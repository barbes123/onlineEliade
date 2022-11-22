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
void GetMatrixIntSum(int run_start = 0, int ver_start = 0, int ver_stop = 1, TString mName="mDelila_raw")
{

  std::cout << "Welcome to the automatic GetMatrixInt macro \n"
	    << "I will calculate statistics in the matrix provided  \n"
	    << std::endl;
        
//  int run = run_start;
 
 TFile *fin;
        
//  TFile *fin = new TFile(Form("selected_run_%i_%i_eliadeS2.root", run, 0),"read"); 
// for (int run = run_start; run<= run_stop; run++){
     
     if(gSystem->AccessPathName(Form("sum_selected_run_%i_%i_%i_eliadeS2.root", run_start, ver_start, ver_stop))){
        std::cout << "File run "<< run_start <<" does not exist" << std::endl;
//        continue;
    };
    
    fin = new TFile (Form("sum_selected_run_%i_%i_%i_eliadeS2.root", run_start, ver_start, ver_stop),"read"); 
    
    TH2F *matrix =  (TH2F*) fin->Get(mName);
    int sumInt = matrix -> GetEntries();
    std::cout<<" run "<< run_start<<" counts " << sumInt <<"\n";
    fin->Close();
//    }
}
