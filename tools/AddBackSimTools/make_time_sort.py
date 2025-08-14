#!/usr/bin/python3

import os
import re
import sys
from pathlib import Path

# CONFIGURATION (EDIT THESE)
lut_sim = {110:5, 109:4, 108:3, 107:2, 106:1, 105:0, 104:-1, 103:-2, 102:-3, 101:-4, 100:-5}
#RUN_NUMBER = 110          # Fixed run number
#CUTCHANGE_PARAM = 5      # Fixed cutchange parameter (e.g., 5 in cutchange5)
#CHANGE_PARAM = lut_sim[RUN_NUMBER]
BASE_DIR = "../root_files"  # Where your folders are
SUFFIX = "cutchange"
SIM_FILE = "sorted_AppsSim_0.root"

def create_symbolic_links(RUN_NUMBER, CHANGE_PARAM):
    try:
        base_path = Path(BASE_DIR)
        print(f"Working directory: {Path.cwd()}")
        print(f"Searching in: {base_path.absolute()}")

        # Handle both positive and negative cutchange values
        folder_pattern = f'10M_unshielded_*{SUFFIX}{CHANGE_PARAM}'
        folders = list(base_path.glob(folder_pattern))
        print(f"Found {len(folders)} matching folders")
        
        success_count = 0
        for folder in folders:
            print(f"\nProcessing: {folder.name}")
            
            # Extract energy (number after 0MeV, e.g., 3 in 0MeV3 → 300keV)
            energy_match = re.search(r'0MeV(\d+)', folder.name)
            if not energy_match:
                print("⚠️ SKIPPED: Couldn't extract energy")
                continue
            energy_kev = int(energy_match.group(1)) * 100
            
            # Verify source file exists
            source_file = folder / f'{SIM_FILE}'
            if not source_file.exists():
                print(f"⚠️ SKIPPED: Missing {source_file}")
                continue
            
            # Create symlink name (run10_300_eliadeS10.root)
            link_name = f"run{RUN_NUMBER}_{energy_kev}_eliadeS10.root"
            try:
                if os.path.lexists(link_name):
                    os.remove(link_name)
                os.symlink(str(source_file), link_name)
                print(f"✅ CREATED: {link_name} -> {source_file}")
                success_count += 1
            except Exception as e:
                print(f"❌ FAILED: {str(e)}")

        print(f"\nResults: Created {success_count}/{len(folders)} symlinks")
        return success_count > 0

    except Exception as e:
        print(f"💥 Fatal error: {str(e)}", file=sys.stderr)
        return False

if __name__ == "__main__":
    for run, par in lut_sim.items():
        success = create_symbolic_links(run, par)
#    	sys.exit(0 if success else 1)
