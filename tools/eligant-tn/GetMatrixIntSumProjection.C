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
void GetMatrixIntSumProjection(int run_start = 0, int run_stop = 0, int ver = 999, int bin1 = 0, int bin2 = 29, TString mName="mDelila_raw")
{

  std::cout << "Welcome to the automatic GetMatrixInt macro \n"
	    << "I will calculate statistics in the matrix provided  \n"
	    << std::endl;
        
//  int run = run_start;

 int ver_start = ver; int ver_stop = ver;
 
 
 for (int runnbr = run_start; runnbr<=run_stop; runnbr++){
 
 
	 TFile *fin;
		
	//  TFile *fin = new TFile(Form("selected_run_%i_%i_eliadeS2.root", run, 0),"read"); 
	// for (int run = run_start; run<= run_stop; run++){
	     
	     if(gSystem->AccessPathName(Form("selected_run_%i_%i_eliadeS2.root", runnbr, ver))){
		std::cout << "File run "<< run_start <<" does not exist" << std::endl;
	//        continue;
	    };
	    
	    fin = new TFile (Form("selected_run_%i_%i_eliadeS2.root", runnbr, ver),"read"); 
	    
	    TH2F *matrix =  (TH2F*) fin->Get(mName);
	    TH1D *_py=matrix->ProjectionY("_py",bin1, bin2);
	//    int sumInt = matrix -> GetEntries();
	    int sumInt = _py -> Integral();
	    std::cout<<" run "<< runnbr<<" counts " << sumInt <<"\n";
	    fin->Close();
	//    }
	};
}
