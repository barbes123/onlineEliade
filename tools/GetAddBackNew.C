#include <iostream>
#include <fstream>
#include <string>
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TCanvas.h"
#include "TString.h"
#include <map>

const int max_fold_new = 40;

void GetAddBackNew(TString filename)
{

  std::cout << "----------------------------------------------------------------------\n"
            << "Welcome to the automatic AddBack macro \n"
	    << "I will prepeare the summed root spectra from the matrix you provided\n"
   	    << "The add back is calculated to Total Spectra from mCores matrix\n"
   	    << "----------------------------------------------------------------------\n"
	    << std::endl;
	    
   TFile *file = TFile::Open(filename, "read");
    if (!file || file->IsZombie()) {
        std::cerr << "Error: Input file "<<  filename << " File could not be opened!" << std::endl;
        return;
    }	    
    
    
    TDirectory *folder = (TDirectory*)file->Get("AddBack");
    if (!folder) {
        std::cerr << "Error: Folder AddBack not found!" << std::endl;
        file->Close();
        return;
    }
    
    
//   TH2F *matrix_0 = file->Get("mEliadeCores");
//    TH2F *matrix_0 = dynamic_cast<TH2F*>(file->Get("mEliadeCores"));
//    if (!matrix_0) {
//        std::cerr << "Error: Matrix mEliadeCores not found!" << std::endl;
//        file->Close();
//       return;
//    }
    
    TH2 *matrix = (TH2*)folder->Get("mFoldSpecSum_1");
    if (!matrix) {
        std::cerr << "Error: Matrix mFoldSpecSum_1 not found!" << std::endl;
        file->Close();
        return;
    }
    

	    
  std::map<int, TH1D*> hFoldSpec;
 
 
  
// TH1D* hZeroSpec;
//  hZeroSpec = matrix_0->ProjectionY("sum_fold_1_1", 11, 14);

    TH1F *sum_fold_1_1 = dynamic_cast<TH1F*>(file->Get("HPGe_single"));
    if (!sum_fold_1_1) {
        std::cerr << "Error: Matrix HPGe_single not found!" << std::endl;
        file->Close();
        return;
    }
    sum_fold_1_1->SetLineColor(2);
    sum_fold_1_1->SetTitle("sum_fold_1_1");
    sum_fold_1_1->SetName("sum_fold_1_1");

    
  TString ofilename = filename.ReplaceAll("selected", "addbackNew");
  TFile *outf = new TFile (ofilename,"recreate");  
  std::cout<<"Output File "<<ofilename<<"\n";
  sum_fold_1_1->Write();
	    
  
  
  
  int fold = 2;
  int sum_fold = 1;
  
  
  
  
  while ((sum_fold != 0)&&(fold <= max_fold_new))
  {
    hFoldSpec[fold] = matrix->ProjectionY(Form("sum_fold_1_%i",fold), 2, fold+1);
    TH1D *py =  matrix->ProjectionY(Form("fold_%i",fold), fold+1, fold+1);
    sum_fold = py->GetEntries();
    outf->cd();
    hFoldSpec[fold]->Write();
    std::cout<<"Fold "<<fold<<" done \n";
    fold++;
  };
  
  outf->Close(); 

}
