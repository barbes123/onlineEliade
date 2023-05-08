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

void GetGammaSpec(int run_start = 44, int run_stop = 44, TString mName="mDelila_raw", int first_bin = 0, int last_bin = 28)
{

  std::cout << "Welcome to the automatic GetGammaSpec macro \n"
	    << "  \n"
	    << std::endl;
        
//  int run = run_start;
 
 TFile *fin;
 TFile *fout;
 std::map<int, TH1D*> hGamma;

 int vernb = 999; //version id for summed runs
 int gammaDOM = 31;
 fout =  new TFile (Form("gamma_run_%i_%i_eliadeS2.root", run_start, run_stop),"recreate"); 

 for (int runnb = run_start; runnb<=run_stop; runnb++){
     if(gSystem->AccessPathName(Form("selected_run_%i_%i_eliadeS2.root", runnb, vernb))){
        std::cout << "File run "<< Form("selected_run_%i_%i_eliadeS2.root", runnb, vernb) <<" does not exist" << std::endl;
        continue;
    };

    std::cout << "I am in file "<< runnb << std::endl;
    
    fin = new TFile (Form("selected_run_%i_%i_eliadeS2.root", runnb, vernb),"read"); 
     
    TH2F *matrix =  (TH2F*) fin->Get("mDelila");

    std::cout << "I got matrix for run "<< runnb << std::endl; 

    hGamma[runnb] = matrix->ProjectionY("_py",gammaDOM, gammaDOM);
    hGamma[runnb]->SetTitle(Form("g_run_%i_dom_%i", runnb, gammaDOM));
    hGamma[runnb]->SetName(Form("g_run_%i_dom_%i", runnb, gammaDOM));

    std::cout << "I got projection for run "<< runnb << std::endl; 
    
  //  TH2F *matrix =  (TH2F*) fin->Get(mName);
   // TH1D *py = matrix->ProjectionY("_py",first_bin, last_bin);
   // int sumInt = matrix -> GetEntries();
   // int sumProj = py->Integral();
    //std::cout<<" run "<< runnb<<" counts full matrix " << sumInt <<" counts projection " << sumProj <<"\n";
 
    fout->cd();
    hGamma[runnb]->Write();
    fin->Close();
	
 };

    fout->Close();
}
