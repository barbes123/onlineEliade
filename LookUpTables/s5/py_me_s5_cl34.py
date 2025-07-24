#!/usr/bin/env python3
import os
import sys
from pathlib import Path

def setup_lut_links(lut_link, lut_path, lut_file, lut_json, lut_ta, lut_conf):
    """Set up the LUT symbolic links with proper error handling."""
    # Remove existing links
    for lut in ["LUT_ELIADE.dat", "LUT_ELIADE.json", "LUT_TA.dat", "LUT_CONF.dat"]:
        link_path = lut_link / lut

        if os.path.islink(link_path):  # Check if it's a symlink
            try:
                target = os.readlink(link_path)  # See where it points
                if not os.path.exists(target):  # Check if target is missing
                    os.unlink(link_path)  # Remove the bad symlink
                    print(f"Removed broken symlink: {link_path}")
            except OSError:
                os.unlink(link_path)  # Remove if we can't even read it
                print(f"Removed corrupted symlink: {link_path}")


        if link_path.exists():
            link_path.unlink()

    # Set up new links
    if lut_file:
        (lut_link / "LUT_ELIADE.dat").symlink_to(lut_path / lut_file)
    
    if lut_json:
        (lut_link / "LUT_ELIADE.json").symlink_to(lut_path / lut_json)
        # Remove .dat link if using json
        dat_link = lut_link / "LUT_ELIADE.dat"
        if dat_link.exists():
            dat_link.unlink()
    
    if lut_ta:
        (lut_link / "LUT_TA.dat").symlink_to(lut_path / lut_ta)
    
    if lut_conf:
        (lut_link / "LUT_CONF.dat").symlink_to(lut_path / lut_conf)

def print_lut_config(lut_file, lut_json, lut_conf, lut_ta):
    """Print the current LUT configuration with colored output."""
    print("--------------------------------------------------------")
    print("Setting of LUT(s)")
    print("--------------------------------------------------------")
    print(f"\033[32mLUT_ELIADE file    : {lut_file}\033[0m")
    print(f"\033[32mLUT_ELIADE json    : {lut_json}\033[0m")
    print(f"\033[32mLUT_CONF file      : {lut_conf}\033[0m")
    print(f"\033[32mLUT_TA file        : {lut_ta}\033[0m")
    print("--------------------------------------------------------")

def main():
    # Parse command line arguments with defaults
    try:
        runnb = int(sys.argv[1])
        runnb1 = int(sys.argv[2]) if len(sys.argv) > 2 else runnb
        volume1 = int(sys.argv[3]) if len(sys.argv) > 3 else 0
        volume2 = int(sys.argv[4]) if len(sys.argv) > 4 else volume1
        nevents = int(sys.argv[5]) if len(sys.argv) > 5 else 0
        AddBAck = int(sys.argv[6]) if len(sys.argv) > 6 else 1
        server = int(sys.argv[7]) if len(sys.argv) > 7 else 5
    except (IndexError, ValueError) as e:
        print("Error: Invalid arguments. Usage:")
        print("[runnb0] [runnb1] [volume1] [volume2] [nevents] [AddBAck] [server]")
        sys.exit(1)

    print("Put Parameters: AddBack (0 - if none); server_nbr (0 - if none); run_nbr; volume_from; volume_to;")
    print(f"RUNfirst      {runnb}")
    print(f"RUNlast       {runnb1}")
    print(f"VOLUMEfirst   {volume1}")
    print(f"VOLUMElast    {volume2}")
    print(f"N EVENTS      {nevents}")
    print(f"ADDBACK       {AddBAck}")
    print(f"SERVER ID     {server}")

    # Setup paths
    home = Path.home()
    lut_path = home / "onlineEliade" / "LookUpTables" / f"s{server}"
    lut_link = home / "EliadeSorting"

    # Ensure directories exist
    lut_link.mkdir(parents=True, exist_ok=True)

    # Default LUT files
    lut_file = ""
    lut_ta = ""
    lut_conf = "LUT_CONF_S5_C34_20250527.dat"
    lut_json = "LUT_ELIADE_S5_CL34_dmitry.json"

    current_run = runnb
    while current_run <= runnb1:
        # Process each volume for the current run
        current_vol = volume1
        while current_vol <= volume2:
            print(f"Now I am starting run the selector run{current_run}_{current_vol}.root")

            if current_run == 197:
                lut_json = "LUT_R196S5/LUT_R196V27S5.json"
                lut_ta = "LUT_TA_R196V0S5_CL34.dat"
            elif current_run == 196:
                lut_json = f"LUT_R{current_run}S{server}/LUT_R{current_run}V{current_vol}S{server}.json"
                if current_run == 196 and current_vol <= 26:                
                    lut_ta = "LUT_TA_R196V0S5_CL34.dat"
                else:
                    print('Board s (SN209 CH0 lost time for ver >=27)')
                    lut_ta = ""
            if current_run == 195:
                lut_json = "LUT_R196S5/LUT_R196V27S5.json"
                lut_ta = "LUT_TA_R196V0S5_CL34.dat"
            elif current_run == 183:
                lut_json = f"LUT_R{current_run}S{server}/LUT_R{current_run}V{current_vol}S{server}.json"
                # lut_json = "LUT_ELIADE_S2_CL30_133Ba_20250708_RUN183.json"
            elif current_run == 171:
                lut_json = f"LUT_R{current_run}S{server}/LUT_R{current_run}V{current_vol}S{server}.json"
 #               lut_json = "LUT_ELIADE_S2_CL30_60Co_20250702_RUN171.json"
                lut_ta = "LUT_TA_R171S2_60C0_20250702.dat"




            # Set up LUT links
            setup_lut_links(lut_link, lut_path, lut_file, lut_json, lut_ta, lut_conf)
            print_lut_config(lut_file, lut_json, lut_conf, lut_ta)


            rootcommand = f"start_me.C+({AddBAck},{server},{current_run},{current_vol},{nevents})"
            exit_code = os.system(f'root -l -b -q "{rootcommand}"')
            if exit_code != 0:
                print(f"Error processing run{current_run}_{current_vol}.root (exit code: {exit_code})")
            else:
                print(f"I finished run{current_run}_{current_vol}.root")
            current_vol += 1

        current_run += 1

if __name__ == "__main__":
    main()
