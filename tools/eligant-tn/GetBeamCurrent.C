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

void GetBeamCurrent(int runnbr, int ver_start = 0, int ver_stop = 0)
{

  std::cout << "Welcome to the automatic GetBeamCurrent macro \n"
	    << "I will calculate beam current in the raw root file provided  \n"
	    << std::endl;

        TFile *fin;
        
 Long64_t beam = 0;
 for (int ver = ver_start; ver<= ver_stop; ver++){
     
     if(gSystem->AccessPathName(Form("../root_files/run%i_%i_adqws.root", runnbr, ver))){
        std::cout << "File run "<< runnbr <<" does not exist" << std::endl;
        continue;
    };
    
    fin = new TFile (Form("../root_files/run%i_%i_adqws.root", runnbr, ver),"read"); 
    TTree *t1 = (TTree*)fin->Get("ELIADE_Tree");
    
    Double_t    TS = 0;
    UChar_t     mod = 0;
    UChar_t     ch = 0;
    UShort_t	fEnergy = 0;//ChargeLong
    
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
	
//     std::cout<<" run "<< runnbr<<" last TS " << TS*1e-12 <<" s; Beam Integral "<<beam  <<" average Beam/TS: "<< beam/(TS*1e-12) <<" \n";
    fin->Close();
    }
    std::cout<<" run "<< runnbr<<" Beam Integral "<< beam  << " \n";
}
