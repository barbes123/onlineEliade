#include <iostream>
#include <fstream>
#include <string>
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TCanvas.h"
#include "TString.h"
#include <map>

const int max_fold = 40;

void GetAddBack(TH2 *matrix)
{

  std::cout << "Welcome to the automatic AddBack macro \n"
	    << "I will prepeare the summed root spectra from the matrix you provided\n"
	    << std::endl;
  std::map<int, TH1D*> hFoldSpec;
  int fold = 1;
  int sum_fold = 1;
  TFile *outf = new TFile ("addbackspectra.root","recreate");
  
  while ((sum_fold != 0)&&(fold <= max_fold))
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
  
/*

  TString mat_name = matrix->GetName();
  Int_t nb_bin_mat  = matrix->GetYaxis()->GetNbins();
  Float_t range_min = matrix->GetYaxis()->GetXmin();
  Float_t range_max = matrix->GetYaxis()->GetXmax();

 TF1 *gaus = new TF1("gaus","gaus", 0,100e3);
 TF1 *gaus2 = new TF1("gaus","gaus", 0,100e3);
 TCanvas *c1 = new TCanvas("c1","c1");
 TH1D *proj_y =new TH1D("projection","proj",nb_bin_mat,range_min,range_max);
 TH1D *proj_y2 =new TH1D("projection2","proj2",nb_bin_mat,range_min,range_max);
 
 int delta = 80000;
 
 for(int jj=0 ; jj<=matrix->GetXaxis()->GetNbins() ; jj++){
 
    matrix->ProjectionY(proj_y->GetName(),jj,jj);    
    if (proj_y->GetEntries() == 0) continue;
//    proj_y->GetXaxis()->SetRangeUser(-50e3,1e6);
    proj_y->GetXaxis()->SetRangeUser(-1e5,1e6);
    
    proj_y->SetTitle(Form("dom%i",jj));
    int max_bin = proj_y->GetMaximumBin();
    int max_bin_pos = proj_y-> GetBinCenter(max_bin);  
        
    c1->cd();
    gaus->SetParameter(1,max_bin_pos);
    gaus->SetParLimits(1,max_bin_pos-10000,max_bin_pos+10000);
    proj_y->Fit(gaus,"MR","",max_bin_pos-delta,max_bin_pos+delta);
    
    
    gaus2->SetParameter(1,gaus->GetParameter(1));
    gaus2->SetParLimits(1,gaus->GetParameter(1) -1000,gaus->GetParameter(1) +1000);
    
    proj_y->Draw();
   
    std::cout<<" dom "<<jj-1<<" max_bin "<<max_bin<<" max bin "<< " max_bin_pos "<< max_bin_pos <<" gaus1 "<<gaus->GetParameter(1)<<" gaus2 "<< gaus2->GetParameter(1) <<"\n";
    std::cout << " domain " << jj-1<<" offset " << proj_y-> GetBinCenter(max_bin) - alignment_pos << " maxbin_pos " << proj_y-> GetBinCenter(max_bin) << std::endl;;
    outputFile << jj-1 << "  " << gaus->GetParameter(1) - alignment_pos <<"\n";;
    
    c1->WaitPrimitive();
    proj_y->Reset();
   }
    outputFile.close();*/
}
