#include <iostream>
#include <fstream>
#include <string>
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TF1.h"
#include "TCanvas.h"
#include "TString.h"
void TimeAlignementTrigger(TH2 *matrix, float alignment_pos=0.)
{

  std::cout << "Welcome to the automatic TimeAlignement macro \n"
	    << "I will calculate by default the offset to put in the LookUpTable\n"
	    << "to put the coincidence peak in "<<alignment_pos <<" , except if you give a second parameter"
	    << std::endl;
  fstream outputFile;
  outputFile.open("TimeCalibCores.dat", ios_base::out);		    

  TString mat_name = matrix->GetName();
  Int_t nb_bin_mat  = matrix->GetYaxis()->GetNbins();
  Float_t range_min = matrix->GetYaxis()->GetXmin();
  Float_t range_max = matrix->GetYaxis()->GetXmax();
 // std::cout<<"range_min "<<range_min<<" range_max "<<range_max<<"\n";
  //TF1 *gaus = new TF1("gaus","gaus", -45e3, 45e3);//for mTimeCalib
 TF1 *gaus = new TF1("gaus","gaus", 2e5, 1e5);
  //    gaus->SetParLimits(1,100e3,300e3);
    //gaus->SetParLimits(0,30,100);
    //gaus->SetParLimits(2,4500,7500);
  TCanvas *c1 = new TCanvas("c1","c1");
  TH1D *proj_y =new TH1D("projection","proj",nb_bin_mat,range_min,range_max);

   for(int jj=0 ; jj<=matrix->GetXaxis()->GetNbins() ; jj++){
       
    matrix->ProjectionY(proj_y->GetName(),jj,jj);
    if (proj_y->GetEntries() == 0) continue;
    proj_y->GetXaxis()->SetRangeUser(-1e5,1e6);
    int max_bin = proj_y->GetMaximumBin();
//     float max_value = proj_y->GetXaxis()->GetBinCenter(max_bin);
    int max_bin_pos = proj_y-> GetBinCenter(max_bin);  
    proj_y->SetTitle(Form("dom%i",jj));
    
    
    c1->cd();
    int fit_range_delta = 50000;
    int fit_pos_delta = 5000;
    gaus->SetParameter(1,max_bin_pos);
    gaus->SetParLimits(1,max_bin_pos-fit_pos_delta,max_bin_pos+fit_pos_delta);
    proj_y->Fit(gaus,"MR","",max_bin_pos-fit_range_delta,max_bin_pos+fit_range_delta);
    proj_y->Draw();

//     int dom1 = jj/100;
//     int dom2 = jj%100;
    
//     std::cout  << " ID " << jj << " dom1 " << dom1 <<" dom2 "<< dom2 << " coincID "<< (dom1*10+9)*1000+(dom2*10+9)  <<" offset fit " << gaus->GetParameter(1) << " offset max bin " << proj_y->GetBinCenter(max_bin)  << std::endl;
    
//     outputFile  << " " << jj << " " << dom1 <<" "<< dom2 << " "<< (dom1*10+9)*1000+(dom2*10+9)  <<" " << gaus->GetParameter(1) << " " << proj_y->GetBinCenter(max_bin)  << std::endl;
    
//     outputFile  << " " << (dom1*10+9)*1000+(dom2*10+9)  <<" " << gaus->GetParameter(1) << " " << proj_y->GetBinCenter(max_bin)  << std::endl;
    
//     outputFile  << " " << jj  <<" " << gaus->GetParameter(1) << " " << proj_y->GetBinCenter(max_bin)  << std::endl;
    
    std::cout  << " DOM " << jj << " offset max bin " << max_bin_pos <<" offset fit " << gaus->GetParameter(1)  << std::endl;
    
    
    outputFile  << " " << jj-1  <<" " << gaus->GetParameter(1) << " \n";//" " << proj_y->GetBinCenter(max_bin)  << std::endl;
    
    
   c1->WaitPrimitive();
    proj_y->Reset();
   }
    outputFile.close();
}
