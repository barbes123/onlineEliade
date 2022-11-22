#include <iostream>
#include <fstream>
#include <string>
#include "TFile.h"
#include "TH1.h"
#include "TH2.h"
#include "TF1.h"
#include "TCanvas.h"
#include "TString.h"

double neutron_time(Double_t *x, Double_t *par) {

    par[1] = 0;
    return exp(-x[0]/par[0])+par[1];
}


double exp_life_time(Double_t *x, Double_t *par) 
{
  par[2]=0;
    return (exp(par[0]+x[0]/par[1])+par[2]);
}; 

void FitNeutronDetectorLife(TH2 *matrix, int bin1=0, int bin2=0, int bg=0) 
{

    std::cout << "Welcome to the automatic Neutron Life Time fit\n"
	    << "I will calculate the neutron Life Time if ELIGANT-TN\n"
	    << "(moderation and diffusion time)"
	    << std::endl; 
        
//     TH1D *py=matrix->ProjectionY("py", bin1, bin2);
    TH1D *py=matrix->ProjectionY(Form("Neutron Lifetime, domains from %i, %i ", bin1, bin2), bin1, bin2);
    TF1 *fit_par2= new TF1("neutron_time",neutron_time, 0.01 ,256e6, 2);
    TF1 *fit_par3= new TF1("exp_life_time",exp_life_time, 0.01 ,256e6, 3);
    
    
    fit_par3->SetParameter(0,6.09668e+00);
    fit_par3->SetParLimits(0,0,10);
    fit_par3->SetParameter(1,-1.01137e-08);  
    fit_par3->SetParLimits(1,-3,0);
    fit_par3->SetParameter(2,bg);  
    fit_par3->SetParLimits(2,bg-100,bg+100);

    
//     fit_t12->SetParameter(0,0.03);
//     fit_t12->SetParameter(1, bg);
    py->Fit(fit_par3,"MR");
        


//   TString mat_name = matrix->GetName();
//   Int_t nb_bin_mat  = matrix->GetYaxis()->GetNbins();
//   Float_t range_min = matrix->GetYaxis()->GetXmin();
//   Float_t range_max = matrix->GetYaxis()->GetXmax();
//  // std::cout<<"range_min "<<range_min<<" range_max "<<range_max<<"\n";
//   //TF1 *gaus = new TF1("gaus","gaus", -45e3, 45e3);//for mTimeCalib
//  TF1 *gaus = new TF1("gaus","gaus", 2e5, 1e5);
//   //    gaus->SetParLimits(1,100e3,300e3);
//     //gaus->SetParLimits(0,30,100);
//     //gaus->SetParLimits(2,4500,7500);
//   TCanvas *c1 = new TCanvas("c1","c1");
//   TH1D *proj_y =new TH1D("projection","proj",nb_bin_mat,range_min,range_max);
// 
//    for(int jj=0 ; jj<=matrix->GetXaxis()->GetNbins() ; jj++){
//        
//     matrix->ProjectionY(proj_y->GetName(),jj,jj);
//     if (proj_y->GetEntries() == 0) continue;
//     proj_y->GetXaxis()->SetRangeUser(-1e5,1e6);
//     int max_bin = proj_y->GetMaximumBin();
// //     float max_value = proj_y->GetXaxis()->GetBinCenter(max_bin);
//     int max_bin_pos = proj_y-> GetBinCenter(max_bin);  
//     proj_y->SetTitle(Form("dom%i",jj));
//     
//     
//     c1->cd();
//     int fit_range_delta = 50000;
//     int fit_pos_delta = 5000;
//     gaus->SetParameter(1,max_bin_pos);
//     gaus->SetParLimits(1,max_bin_pos-fit_pos_delta,max_bin_pos+fit_pos_delta);
//     proj_y->Fit(gaus,"MR","",max_bin_pos-fit_range_delta,max_bin_pos+fit_range_delta);
//     proj_y->Draw();
// 
// //     int dom1 = jj/100;
// //     int dom2 = jj%100;
//     
// //     std::cout  << " ID " << jj << " dom1 " << dom1 <<" dom2 "<< dom2 << " coincID "<< (dom1*10+9)*1000+(dom2*10+9)  <<" offset fit " << gaus->GetParameter(1) << " offset max bin " << proj_y->GetBinCenter(max_bin)  << std::endl;
//     
// //     outputFile  << " " << jj << " " << dom1 <<" "<< dom2 << " "<< (dom1*10+9)*1000+(dom2*10+9)  <<" " << gaus->GetParameter(1) << " " << proj_y->GetBinCenter(max_bin)  << std::endl;
//     
// //     outputFile  << " " << (dom1*10+9)*1000+(dom2*10+9)  <<" " << gaus->GetParameter(1) << " " << proj_y->GetBinCenter(max_bin)  << std::endl;
//     
// //     outputFile  << " " << jj  <<" " << gaus->GetParameter(1) << " " << proj_y->GetBinCenter(max_bin)  << std::endl;
//     
//     std::cout  << " DOM " << jj << " offset max bin " << max_bin_pos <<" offset fit " << gaus->GetParameter(1)  << std::endl;
//     
//     
//     outputFile  << " " << jj-1  <<" " << gaus->GetParameter(1) << " \n";//" " << proj_y->GetBinCenter(max_bin)  << std::endl;
//     
//     
//    c1->WaitPrimitive();
//     proj_y->Reset();
//    }
//     outputFile.close();
}
