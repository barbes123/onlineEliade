#include <iostream>
#include <fstream>
#include <string>
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TF1.h"
#include "TCanvas.h"
#include "TString.h"
void TimeAlignementTrigger(TH2 *matrix, float alignment_pos=0., int start_domain = 0)
{

  std::cout << "Welcome to the automatic TimeAlignement macro \n"
	    << "I will calculate by default the offset to put in the LookUpTable\n"
	    << "to put the coincidence peak in "<<alignment_pos <<" , except if you give a second parameter"
	    << std::endl;
  fstream outputFile1;
 fstream outputFile2;
  outputFile1.open("TimeCalibGaussian.dat", ios_base::out);		    
  outputFile2.open("TimeCalibMaxBin.dat", ios_base::out);		    

  TString mat_name = matrix->GetName();
  Int_t nb_bin_mat  = matrix->GetYaxis()->GetNbins();
  Float_t range_min = matrix->GetYaxis()->GetXmin();
  Float_t range_max = matrix->GetYaxis()->GetXmax();

 TF1 *gaus = new TF1("gaus","gaus", 0,100e3);
 TF1 *gaus2 = new TF1("gaus","gaus", 0,100e3);
 TCanvas *c1 = new TCanvas("c1","c1");
 TH1D *proj_y =new TH1D("projection","proj",nb_bin_mat,range_min,range_max);
 TH1D *proj_y2 =new TH1D("projection2","proj2",nb_bin_mat,range_min,range_max);
 
 int delta = 10000;
 
 for(int jj=0 ; jj<=matrix->GetXaxis()->GetNbins() ; jj++){
 
    if (jj < start_domain) continue;
    matrix->ProjectionY(proj_y->GetName(),jj,jj);    
    if (proj_y->GetEntries() == 0) continue;
//    proj_y->GetXaxis()->SetRangeUser(-50e3,1e6);
    proj_y->GetXaxis()->SetRangeUser(-1e5,2e5);
    
    proj_y->SetTitle(Form("dom%i",jj));
    int max_bin = proj_y->GetMaximumBin();
    int max_bin_pos = proj_y-> GetBinCenter(max_bin);  
        
    c1->cd();
    gaus->SetParameter(1,max_bin_pos);
    gaus->SetParLimits(1,max_bin_pos-1000,max_bin_pos+1000);
    proj_y->Fit(gaus,"MR","",max_bin_pos-delta,max_bin_pos+delta);
    
    
    gaus2->SetParameter(1,gaus->GetParameter(1));
    gaus2->SetParLimits(1,gaus->GetParameter(1) -1000,gaus->GetParameter(1) +1000);
    
    proj_y->Draw();
   
    std::cout<<" dom "<<jj-1<<" max_bin "<<max_bin<<" max bin "<< " max_bin_pos "<< max_bin_pos <<" gaus1 "<<gaus->GetParameter(1)<<" gaus2 "<< gaus2->GetParameter(1) <<"\n";
    std::cout << " domain " << jj-1<<" offset " << proj_y-> GetBinCenter(max_bin) - alignment_pos << " maxbin_pos " << proj_y-> GetBinCenter(max_bin) << std::endl;;
    outputFile1 << jj-1 << "  " << gaus->GetParameter(1) - alignment_pos <<"\n";;
    outputFile2 << jj-1 << "  " <<  max_bin_pos - alignment_pos <<"\n";;
    
    c1->WaitPrimitive();
    proj_y->Reset();
   }
    outputFile1.close();
    outputFile2.close();
}
