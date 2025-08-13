#include "TChain.h"
#include "TProof.h"
#include "TFile.h"
#include <sstream>
#include <string>
#include <iostream> 
#include <TROOT.h>
using namespace std;




void addback_me(UInt_t AddBAck = 0, int serverID=10, UInt_t first_run=3, UInt_t vol0=100){

  std::cout<<" addback_me.C is running "<< AddBAck << " - option"<<std::endl;
  
  
 TString home_path1 = gSystem->GetFromPipe("echo $HOME");
// gROOT->ProcessLine(Form(".L %s/onlineEliade/tools/hconverter.C+",home_path1.Data()));
// gROOT->ProcessLine(Form(".L %s/onlineEliade/tools/GetAddBack.C+",home_path1.Data()));
// gROOT->ProcessLine(Form(".L %s/onlineEliade/tools/GetAddBackNew.C+",home_path1.Data()));


 

 
 UInt_t vol1 = vol0;  
 UInt_t last_run = first_run;
 string data_path = "/eliadedisks/simul/selector_dmitry"; 
 string suffix = Form("eliadeS%i",serverID);
 string file_name_prefix = "selected_run_";
 
//  if (serverID < 10)  data_path = Form("/eos/eliade/s%i/selector_dmitry",serverID);
// if (serverID < 10)  data_path = Form("");
  
 for(UInt_t run=first_run;run<=last_run;++run){     
 	for (UInt_t vol=vol0;vol<=vol1;++vol){
         
        TChain *ch = new TChain("ELIADE_Tree","ELIADE_Tree");
        string szRun, szVol;

        szRun = Form("%i",run); szVol = Form("%i",vol);

        std::stringstream ifile;
//         ifile<<Form("%s/%s%s_%s_%s.root", data_path.c_str(), file_name_prefix.c_str(), szRun.c_str(),szVol.c_str(), suffix.c_str());
        ifile<<Form("%s%s_%s_%s.root", file_name_prefix.c_str(), szRun.c_str(),szVol.c_str(), suffix.c_str());
        
        
         TFile *file = TFile::Open(ifile.str().c_str(), "READ");
    
         if (!file || file->IsZombie()) {
	     std::cerr << "Error opening the file!" << std::endl;
            return;
         }
         

         if(gSystem->AccessPathName(ifile.str().c_str())){
	        std::cout << "File "<<ifile.str().c_str()<<" does not exist, skipping" << std::endl;
	        continue;
    	} else {  	
   	        std::cout << "File "<<ifile.str().c_str()<<"  exists! " << std::endl;
    	        if (AddBAck == 1){
	              std::cout << " GetAddBack.C \n";
			      std::cout << Form("TFile *file = TFile::Open(\"%s\", \"READ\")",ifile.str().c_str()) << std::endl;
			
			      gROOT->ProcessLine(Form("TFile *file = TFile::Open(\"%s\", \"READ\")",ifile.str().c_str()) );
	      	      gROOT->ProcessLine("file->cd(\"AddBack\")");
	      	        
     			  std::cout << ">>> I am starting GetAddBack.C(AddBack/mFoldSpecSum_1)" << std::endl;
                  std::cout << Form(".x %s/onlineEliade/tools/AddBackSimTools/GetAddBack.C(AddBack/mFoldSpecSum_1)",home_path1.Data()) << std::endl;
                  gROOT->ProcessLine(Form(".x %s/onlineEliade/tools/AddBackSimTools/GetAddBack.C(mFoldSpecSum_1)",home_path1.Data()) );
                  std::cout << ">>> I finished GetAddBack.C(AddBack/mFoldSpecSum_1)"<< std::endl;
			
	      	      gROOT->ProcessLine("file->cd(\"AddBack\")");
   			      std::cout << Form(".x %s/onlineEliade/tools/AddBackSimTools/GetTimeSpec.C(AddBack/mTimeDiffCoreCore_10)",home_path1.Data()) << std::endl;
                  gROOT->ProcessLine(Form(".x %s/onlineEliade/tools/AddBackSimTools/GetTimeSpec.C(mTimeDiffCoreCore_10)",home_path1.Data()) );
			}			
		else if (AddBAck == 0){
	                std::cout << " GetAddBackNew.C \n";
	      

			gROOT->ProcessLine(Form(".x %s/onlineEliade/tools/GetAddBackNew.C+(\"%s\")", home_path1.Data(), ifile.str().c_str()));

	                
	                
		//	gROOT->ProcessLine(Form(".x %s/onlineEliade/tools/GetAddBackNew.C+(%s)",home_path1.Data(), ifile.str().c_str() ) );		
		};

	   };
	};   
  };
}

