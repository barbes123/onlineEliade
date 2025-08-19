#! /usr/bin/python3


import os, sys, json
import argparse

def UpdateSymboliLink(server, run):#not necessary here, i moved to py_addback.py

    lut_recall_found = False

    ourpath = os.getenv('PY_CALIB')
    js_file = ourpath + f'/json/run_table_S{server}.json'
    isExist = os.path.exists(js_file)
    if isExist:
        print(f'Data file {js_file} found')
        with open(js_file, 'r') as file:
            js_data =  json.load(file)
        source = ''
        for el in js_data:
            if el['runNumber'] == run:
                source = el['source']
                break
        print(f'Source {source} automatically detected from {js_file}')

        js_lut_recall = ourpath + f'/json/lut_recall/{source}.json'

        if os.path.exists(js_lut_recall):
            lut_recall_found = True
            print(f'{js_lut_recall} is found')
        else:
            print(f'{js_lut_recall} not found')

        if lut_recall_found:
            lut_recall = ourpath + '/LUT_RECALL.json'
            if os.path.exists(lut_recall):
                os.unlink(lut_recall)
            os.symlink(js_lut_recall, lut_recall)
            print(f"Symbolic link created: {js_file} -> {lut_recall}")
        else:
            print('Link manually LUT_RECALL.json')
    else:
        print(f'Data file {js_file} not found')
        print('Link manually LUT_RECALL.json')

def main():
    parser = argparse.ArgumentParser(description="Process run and volume parameters.")
    parser.add_argument("-r", "--run", type=int, nargs=2, required=True, help="Range of run numbers (start end)")
    parser.add_argument("-v", "--volume", type=int, nargs=2, default=[0, 0], help="Range of volume numbers (start end, default: 0 0)")
    parser.add_argument("-ab", type=int, default=0, help="AddBack parameter (default: 0)")
    parser.add_argument("-s", "--server", type=int, default=10, help="Server number (default: 10)")
    parser.add_argument("-d", "--dvol", type=int, default=100, help="Volume increment (default: 100)")

    args = parser.parse_args()

    runnb1, runnb2 = args.run
    volume1, volume2 = args.volume
    AddBack = args.ab
    server = args.server
    dvol = args.dvol



    print("Put Parameters: AddBack (0 - if none); server_nbr (0 - if none); run_nbr; volume_from; volume_to;")
    print(f"RUNfirst      {runnb1}")
    print(f"RUNlast       {runnb2}")
    print(f"VOLUMEfirst   {volume1}")
    print(f"VOLUMElast    {volume2}")
    print(f"ADDBACK       {AddBack}")
    print(f"SERVER ID     {server}")
    print(f"INCREMENT     {dvol}")

    runnb = runnb1

    while runnb <= runnb2:
        print(f"Trying for run {runnb}")
        volnb = volume1
        # UpdateSymboliLink(server, runnb)

        while volnb <= volume2:
            name = f"selected_run_{runnb}_{volnb}_eliadeS{server}.root"

            if os.path.exists(name):
                print(f"{name} found")
            else:
                print(f"{name} is missing")
                volnb += dvol
                continue

            print(f"Now I am starting addback_me.C for {name}")
            root_command = f"{os.getenv('HOME')}/onlineEliade/tools/AddBackSimTools/addback_me.C+({AddBack},{server},{runnb},{volnb})"
            os.system(f'root -l -b -q "{root_command}"')

            print(f"I finished run{runnb}_{volnb}.root")

            if os.path.exists("addbackspectra.root"):
                os.rename("addbackspectra.root", f"addback_run_{runnb}_{volnb}_eliadeS{server}.root")

            if os.path.exists("timespectra.root"):
                os.rename("timespectra.root", f"ts_run_{runnb}_{volnb}_eliadeS{server}.root")

            print("Starting hconverter_ab.C")
            root_command = f"{os.getenv('HOME')}/onlineEliade/tools/AddBackSimTools/hconverter_ab.C({runnb},{volnb},{server})"
            print(root_command)
            os.system(f'root -l -b -q "{root_command}"')

            print("Starting hconverter_ts.C")
            root_command = f"{os.getenv('HOME')}/onlineEliade/tools/AddBackSimTools/hconverter_ts.C({runnb},{volnb},{server})"
            print(root_command)
            os.system(f'root -l -b -q "{root_command}"')

            volnb += dvol

        runnb += dvol


if __name__ == "__main__":
    main()
