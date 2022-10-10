#include <iostream>
#include <fstream>
#include <string>
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TCanvas.h"
#include "TString.h"
#include "TTree.h"
#include <map>
#include <TSystem.h>

// void GetMatrixInt(TH2 *matrix)
void GetLastTS(int run_start = 0, int run_stop = 0)
{

  std::cout << "Welcome to the automatic GetLastTS macro \n"
	    << "I will calculate statistics in the matrix provided  \n"
	    << std::endl;
        
//  int run = run_start;
 
 TFile *fin;
        
//  TFile *fin = new TFile(Form("selected_run_%i_%i_eliadeS2.root", run, 0),"read"); 
 for (int run = run_start; run<= run_stop; run++){
     
     if(gSystem->AccessPathName(Form("run%i_%i_adqws.root", run, 0))){
        std::cout << "File run "<< run <<" does not exist" << std::endl;
        continue;
    };
    
    fin = new TFile (Form("run%i_%i_adqws.root", run, 0),"read"); 
    TTree *t1 = (TTree*)fin->Get("ELIADE_Tree");
    
    Double_t TS = 0;
    UChar_t mod = 0;
    UChar_t ch = 0;
    Long64_t beam = 0;
    UShort_t	    fEnergy;//ChargeLong
    
    Int_t nentries = (Int_t)t1->GetEntries();
    t1->SetBranchAddress("FineTS",&TS);
    t1->SetBranchAddress("Mod",&mod);
    t1->SetBranchAddress("Ch", &ch);
    t1->SetBranchAddress("ChargeLong", &fEnergy);
//     t1->GetEntry(nentries);
    
    
    for (Int_t i = 0; i<=nentries;i++){
     
      t1->GetEntry(i);
      
      if ((mod == 2) && (ch == 15)) beam+=fEnergy;
//        std::cout<<" run "<< run<<" last TS " << TS <<"\n";
	}
	
    std::cout<<" run "<< run<<" last TS " << TS*1e-12 <<" s; Beam Integral "<<beam  <<" average Beam/TS: "<< beam/(TS*1e-12) <<" \n";
    fin->Close();
    }
}
