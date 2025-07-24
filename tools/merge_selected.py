#!/usr/bin/env python3
import os
import sys
from pathlib import Path

server_default = 5

def merge_eliade_files(server, run1, run2, volume1, volume2):
    """Merge ELIADE selector files for runs from first_run to last_run"""
    suffix = f"eliadeS{server}"
    prefix = "selected_run"

    print(f"Merge raw files for runs from {run1} to {run2} for volumes {volume1} {volume2}")

    for runnb in range(run1, run2 + 1):
        volnb = volume1
        fileout = f"sum_{prefix}_{runnb}_{volume1}_{volume2}_{suffix}.root"
        print(f'OutPut File: {fileout}')

        command = f"hadd sum_{prefix}_{runnb}_{volume1}_{volume2}_{suffix}.root "

        if Path(fileout).exists():
            os.remove(fileout)
            print(f'previous OutPut File: {fileout} is deleted')
        for volnb in range(volume1, volume2 + 1):
            current_file = f"{prefix}_{runnb}_{volnb}_{suffix}.root"
            print(f"File {current_file} ")
            # volume1 = 0
            # volnb = volume1

            # flag = True  # 1 - file found
            # flag = True  # 1 - file found


            # if Path(current_file).exists():
            #     command += f"{current_file} "
            #     print(command)


            if Path(current_file).exists():
                command += f"{current_file} "
                print(f"File {current_file} added ")
            volnb += 1
        print(f'Command {command}')
        os.system(command)

            # while flag:
            #
            #     print(f"current_file: {current_file}")
            #
            #     if Path(current_file).exists():
            #         command += f"{current_file} "
            #         print(command)
            #         volnb += 1
            #     else:
            #         flag = False
            #         break
            #
            # print(command)


        # Rename the output file
        # filesave = f"run{runnb}_999_{suffix}.root"
        # if Path(fileout).exists():
        #     os.rename(fileout, filesave)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Merfing the files like selected_run_100_12_eliadeS2.root")
        print(f"Usage: [run1] [run2 = run1 default] [vol1 = 0 default] [vol2 = vol1 default] [server = {server_default}")
        sys.exit(1)

    run1 = int(sys.argv[1])
    run2 = int(sys.argv[2]) if len(sys.argv) > 2 else run1
    volume1 = int(sys.argv[3]) if len(sys.argv) > 3 else 0
    volume2 = int(sys.argv[4]) if len(sys.argv) > 4 else volume1
    server = int(sys.argv[5]) if len(sys.argv) > 5 else server_default

    merge_eliade_files(server, run1, run2, volume1, volume2)
