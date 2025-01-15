#!/usr/bin/python3

import os
import subprocess
import argparse

def RunTimeSort():
    # Get the current directory where the script is executed
    current_dir = os.getcwd()
    home_dir = os.getenv("HOME")  # Get the home directory
    root_script_path = os.path.join(home_dir, 'onlineEliade/tools/SimTools/sort_AppsSim_0.cpp')
    
    # Loop through both index ranges (0 to 9)
    for i in range(10):  # First index from 0 to 9
        for j in range(10):  # Second index from 0 to 9
            # Construct folder name
            folder_name = f'10M_unshielded_{i}MeV{j}'  
            folder_path = os.path.join(current_dir, folder_name)

            # Check if the folder exists
            if os.path.isdir(folder_path):  
                print(f"Running script in folder: {folder_path}")

                # Change to the folder
                os.chdir(folder_path)

                # Run the ROOT script in that folder
                command = f"root -l -q {root_script_path}"
#                command = f".q"  
                print(command)

                try:
                    subprocess.run(command, shell=True, check=True)
                    print(f"Successfully ran script in {folder_path}")
                except subprocess.CalledProcessError as e:
                    print(f"Error running script in {folder_path}: {e}")
                
                # Change back to the original directory after running the script
                os.chdir(current_dir)
            else:
                print(f"Folder {folder_path} does not exist.")
                

def SymBolicLinks(run_index):
    # Get the current directory where the script is executed
    current_dir = os.getcwd()
 #   home_dir = os.getenv("HOME")  # Get the home directory
#    root_script_path = os.path.join(home_dir, 'onlineEliade/tools/SimTools/sort_AppsSim_0.cpp')
    
    # Loop through both index ranges (0 to 9)
    for i in range(10):  # First index from 0 to 9
        for j in range(10):  # Second index from 0 to 9
            # Construct folder name
            folder_name = f'10M_unshielded_{i}MeV{j}'  
            folder_path = os.path.join(current_dir, folder_name)

            # Check if the folder exists
            if os.path.isdir(current_dir):   
                # Generate the symbolic link
                generated_value = i * 1000 + j * 100
                symbolic_link_name = f"run{run_index}_{generated_value}_eliadeS10.root"
                target_file = os.path.join(folder_path, 'sorted_AppsSim_0.root')
                symbolic_link_path = os.path.join(current_dir, symbolic_link_name)

                # If the symbolic link already exists, unlink it first
                if os.path.islink(symbolic_link_path):
                    print(f"Unlinking existing symbolic link: {symbolic_link_path}")
                    os.unlink(symbolic_link_path)

                # Create the new symbolic link
                print(f"Creating symbolic link: {symbolic_link_path} -> {target_file}")
                os.symlink(target_file, symbolic_link_path)

                # Change back to the original directory after running the script
                os.chdir(current_dir)
            else:
                print(f"Folder {folder_path} does not exist.")

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Run ROOT script and create symbolic links in indexed folders.")
    parser.add_argument('run_index', type=int, help="Run number")

    # Parse arguments
    args = parser.parse_args()


    RunTimeSort()
    SymBolicLinks(args.run_index)

if __name__ == "__main__":
    main()

