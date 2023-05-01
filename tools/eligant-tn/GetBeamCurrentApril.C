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

void GetBeamCurrentApril(int run_start, int run_stop, int ver_start = 0, int ver_stop = 0)
{

  std::cout << "Welcome to the automatic GetBeamCurrent macro \n"
	    << "I will calculate beam current and run duration in the raw root file provided  \n"
	    << "For the experiment in April 2023 \n"
	    << std::endl;

 TFile *fin;        
 Long64_t 	beam = 0;
 Double_t    	TS = 0;
 UChar_t     	mod = 0;
 UChar_t     	ch = 0;
 UShort_t    	fEnergy = 0;//ChargeLong


 for (int runnbr = run_start; runnbr<= run_stop; runnbr++){
 
 
 for (int ver = ver_start; ver<= ver_stop; ver++){
     
     if(gSystem->AccessPathName(Form("../root_files/run%i_%i_adqws.root", runnbr, ver))){
        std::cout << "File run "<< runnbr <<" does not exist" << std::endl;
        continue;
    };
    
    fin = new TFile (Form("../root_files/run%i_%i_adqws.root", runnbr, ver),"read"); 
    TTree *t1 = (TTree*)fin->Get("ELIADE_Tree");

    Int_t nentries = (Int_t)t1->GetEntries();
    t1->SetBranchAddress("FineTS",&TS);
    t1->SetBranchAddress("Mod",&mod);
    t1->SetBranchAddress("Ch", &ch);
    t1->SetBranchAddress("ChargeLong", &fEnergy);
//     t1->GetEntry(nentries);
    
    
    beam = 0;
    for (Int_t i = 0; i<=nentries;i++){
     
      t1->GetEntry(i);
      
      if ((mod == 2) && (ch == 14)) beam++;//beam+=fEnergy;
//        std::cout<<" run "<< run<<" last TS " << TS <<"\n";
	}
	
    fin->Close();
    std::cout<<" run "<< runnbr<< " version "<<ver <<" last TS " << TS*1e-12 <<" s; Beam Integral "<<beam  <<" average Beam/TS: "<< beam/(TS*1e-12) <<" \n";
    }
   }
//    std::cout<<" run "<< runnbr<<" Beam Integral "<< beam  << " \n";

}
