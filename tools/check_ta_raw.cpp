#include <iostream>
#include <iomanip>
#include <vector>
#include <algorithm>
#include <tuple>

#include <TFile.h>
#include <TTree.h>
#include <TH1.h>
#include <TH2.h>


typedef std::tuple<Int_t, Double_t> TS_t; // Mod and FineTS
std::vector<std::vector<TS_t>> eveVector;
TH2D *hist;

void check_ta_raw(Int_t runNo = 103)
{
  TString fileName = "/eliadedisks/s9/root_files/run" + std::to_string(runNo) + "_0_eliadeS9.root";
  auto file = new TFile(fileName, "READ");
  auto tree = (TTree*)file->Get("ELIADE_Tree");
  tree->Print();

  tree->SetBranchStatus("*", kFALSE);

  UChar_t mod, ch;
  tree->SetBranchStatus("Mod", kTRUE);
  tree->SetBranchAddress("Mod", &mod);
  tree->SetBranchStatus("Ch", kTRUE);
  tree->SetBranchAddress("Ch", &ch);

  Double_t ts;
  tree->SetBranchStatus("FineTS", kTRUE);
  tree->SetBranchAddress("FineTS", &ts);

  std::vector<TS_t> tsVector;
  
  const auto nEvents = tree->GetEntries();
  for(auto iEve = 0; iEve < nEvents; ++iEve){
    tree->GetEntry(iEve);

    if(ch == 15 || ((mod == 28 || mod == 29) && ch == 7)) {
      tsVector.push_back(std::make_tuple(mod, ts / 1000.));
    }
  }

  std::cout << tsVector.size() << std::endl;
  
  std::sort(tsVector.begin(), tsVector.end(),
	    [](const TS_t &a, const TS_t &b) {
	      return std::get<1>(a) < std::get<1>(b);
	    });

  std::cout << tsVector.size() << std::endl;

  //std::cout << setprecision(12);
  //for(auto &&ele: tsVector){
  //std::cout << std::get<0>(ele) <<"\t"<< std::get<1>(ele) << std::endl;
  //}
  std::cout << setprecision(12);
  const auto nHits = tsVector.size();
  for(auto i = 0; i < nHits; ) {
    auto ref = std::get<1>(tsVector[i]);
    const UInt_t loopLength = 34;
    std::vector<TS_t> tmp;
    for(auto j = 0; j < loopLength; ++j) {
      if(std::get<1>(tsVector[i]) - ref < 1000) {
	//std::cout << std::get<0>(tsVector[i]) <<"\t"<< std::get<1>(tsVector[i]) <<"\t"<< ref << std::endl;
	tmp.push_back(tsVector[i]);
      } else {
	//std::cout << std::get<1>(tsVector[i]) <<"\t"<< ref << std::endl;
	std::cerr << "The time sequence is not good." << std::endl;
      }
      i++;
    }

    std::sort(tmp.begin(), tmp.end(),
	      [](const TS_t &a, const TS_t &b) {
		return std::get<0>(a) < std::get<0>(b);
	      });
      
    eveVector.push_back(tmp);
  }

  hist = new TH2D("hist", "Time diff", 2001, -1000.5, 1000.5, 34, -0.5, 33.5);
  for(auto &eve: eveVector){
    auto ref = std::get<1>(eve[0]); // After sorting, this is mod 0
    for(auto i = 0; i < eve.size(); i++){
      auto mod = std::get<0>(eve[i]);
      auto diff = std::get<1>(eve[i]) - ref;
      hist->Fill(diff, mod);
    }

  }


  hist->Draw("COLZ");
}
