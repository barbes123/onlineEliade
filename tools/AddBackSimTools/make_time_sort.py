#!/usr/bin/python3

import os
import re
import sys
import subprocess
from pathlib import Path

# CONFIGURATION
RUN_NUMBER = 100
#CUTCHANGE_PARAM = -5
BASE_DIR = ""
#lut_sim = {110:5, 109:4, 108:3, 107:2, 106:1, 105:0, 104:-1, 103:-2, 102:-3, 101:-4, 100:-5}
lut_sim = {200:4, 201:"4_5", 202:5, 203:"5_5", 204:6, 205:"6_5", 206:7, 207:"7_5"}
#SUFFIX = "cutchange"
SUFFIX = "wellradius"
ROOT_SCRIPT_PATH = "~/onlineEliade/tools/SimTools/sort_AppsSim_0.cpp"


def process_folders(par):
    try:
        # Get absolute path of ROOT script
        root_script_path = os.path.expanduser(ROOT_SCRIPT_PATH)
        if not os.path.exists(root_script_path):
            print(f"Error: ROOT script not found at {root_script_path}")
            return False

        # Store original directory
        current_dir = os.getcwd()
        
        # Find all matching folders
        base_path = Path(BASE_DIR)
        folders = list(base_path.glob(f'10M_unshielded_*{SUFFIX}{par}'))
        
        if not folders:
            print(f"No folders found matching pattern: *{SUFFIX}{par}")
            return False

        success_count = 0
        for folder in folders:
            folder_path = str(folder)
            print(f"\nProcessing folder: {folder_path}")

            if os.path.isdir(folder_path):  
                print(f"Running script in folder: {folder_path}")

                # Change to the folder
                os.chdir(folder_path)

                # Run the ROOT script in that folder
                command = f"root -l -q {root_script_path}"
                print(command)

                try:
                    subprocess.run(command, shell=True, check=True)
#                    print(f"Successfully ran script in {folder_path}")
#                    
#                    # After running, rename output file according to pattern
#                   energy_match = re.search(r'0MeV(\d+)', folder.name)
#                    if energy_match:
#                        energy_kev = int(energy_match.group(1)) * 100
#                        output_name = f"run{RUN_NUMBER}_{energy_kev}_eliadeS10.root"
#                        if os.path.exists("AppsSim_0.root"):
#                            os.rename("AppsSim_0.root", output_name)
#                            print(f"Renamed output to {output_name}")
#                            success_count += 1
                except subprocess.CalledProcessError as e:
                    print(f"Error running script in {folder_path}: {e}")
                
                # Change back to the original directory after running the script
                os.chdir(current_dir)
            else:
                print(f"Folder {folder_path} does not exist.")

        print(f"\nSuccessfully processed {success_count}/{len(folders)} folders")
        return success_count > 0

    except Exception as e:
        print(f"Fatal error: {str(e)}", file=sys.stderr)
        return False

if __name__ == "__main__":
    for run, par in lut_sim.items():
        success = process_folders(par)
#    success = process_folders()
#    sys.exit(0 if success else 1)
