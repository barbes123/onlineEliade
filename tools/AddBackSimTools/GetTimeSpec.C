#include <iostream>
#include <fstream>
#include <string>
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TCanvas.h"
#include "TString.h"
#include <map>


void GetTimeSpec(TH2 *matrix)
{	    
   std::cout << "----------------------------------------------------------------------\n"
            << "Welcome to the automatic GetTimeDiff for Add macro \n"
   	    << "----------------------------------------------------------------------\n"
	    << std::endl;	    
	    
  std::map<int, TH1D*> hFoldSpec;
  int fold = 1;
  int sum_fold = 1;
  TFile *outf = new TFile ("timespectra.root","recreate");
  TH1D *py_time = matrix->ProjectionY("timespec");
  py_time->SetTitle("timespec");
  py_time->SetName("timespec");
  outf->cd();
  py_time->Write();
	
  std::cout<<"py_time saved \n";
  
  outf->Close();  
}
