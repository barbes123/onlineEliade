#include "TChain.h"
#include "TProof.h"
#include "TFile.h"
#include <sstream>
#include <string>
#include <iostream> 
#include <TROOT.h>
using namespace std;




void addback_me(UInt_t AddBAck = 0, int serverID=10, UInt_t first_run=3, UInt_t vol0=100, int nevents=0){

 
 TString home_path1 = gSystem->GetFromPipe("echo $HOME");
 gROOT->ProcessLine(Form(".L %s/onlineEliade/tools/hconverter.C+",home_path1.Data()));
 gROOT->ProcessLine(Form(".L %s/onlineEliade/tools/GetAddBack.C+",home_path1.Data()));


 
 std::cout<<" sorting_eliade.C is running "<<std::endl;
 
 UInt_t vol1 = vol0;  
 UInt_t last_run = first_run;
 string data_path = "/eliadedisks/simul/selector_dmitry";  
// string suffix = "ssgant1";
 string suffix = Form("eliadeS%i",serverID);
 string file_name_prefix = "selected_run_";
  
 for(UInt_t run=first_run;run<=last_run;++run){     
 	for (UInt_t vol=vol0;vol<=vol1;++vol){
         
        TChain *ch = new TChain("ELIADE_Tree","ELIADE_Tree");
        string szRun, szVol;

        szRun = Form("%i",run); szVol = Form("%i",vol);

        std::stringstream ifile;
        ifile<<Form("%s/%s%s_%s_%s.root", data_path.c_str(), file_name_prefix.c_str(), szRun.c_str(),szVol.c_str(), suffix.c_str());
        
        
         TFile *file = TFile::Open(ifile.str().c_str(), "READ");
    
         if (!file || file->IsZombie()) {
	     std::cerr << "Error opening the file!" << std::endl;
            return;
         }
         
         
//        TH2F *mFoldSpecSum_1 = (TH1F*)file->Get("AddBack/mFoldSpecSum_1");  // Replace "hist_name" with the actual histogram name
/*        if (mFoldSpecSum_1) {
            std::cout << "Histogram loaded successfully!" << std::endl;

        } else {
            std::cerr << "Histogram not found in the file!" << std::endl;
        }
  */      
        
         if(gSystem->AccessPathName(ifile.str().c_str())){
	        std::cout << "File "<<ifile.str().c_str()<<" does not exist, skipping" << std::endl;
	        continue;
    	} else {
    	
//    		char char_array[ifile.str().c_str().length() + 1];  // +1 for null terminator
  // 	        std::strcpy(char_array, ifile.str().c_str());
    	
    	
    	
	        std::cout << "File "<<ifile.str().c_str()<<"  exists! " << std::endl;
	        std::cout << Form("TFile *file = TFile::Open(\"%s\", \"READ\")",ifile.str().c_str()) << std::endl;
	        gROOT->ProcessLine(Form("TFile *file = TFile::Open(\"%s\", \"READ\")",ifile.str().c_str()) );
      	        gROOT->ProcessLine("file->cd(\"AddBack\")");
        	std::cout << Form(".x %s/onlineEliade/tools/GetAddBack.C+(AddBack/mFoldSpecSum_1)",home_path1.Data()) << std::endl;
        	gROOT->ProcessLine(Form(".x %s/onlineEliade/tools/GetAddBack.C+(mFoldSpecSum_1)",home_path1.Data()) );
		std::cout <<"  here " << std::endl;

	   };
	};   
  };
}

