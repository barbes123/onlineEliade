#! /usr/bin/python3

import json
import sys
from os.path import exists

# file_lut = 'LUT_CL31_20220725_run93_DT.dat'
file_lut = 'LUT_ELIADE_S9_run20_raluca.dat'
file_calib = 'eliade.coeff'
file_calib_json = 'eliade.json'
file_json = 'LUT_ELIADE_CL29.json'

blModifyCalib = False
if (len(sys.argv) > 1):
    file_lut = sys.argv[1]

if (len(sys.argv) > 2 ):
    blModifyCalib = True
    file_calib = sys.argv[2]

if (not file_lut):
    print('No file {}',(file_lut))
    exit()

if (blModifyCalib and (not file_calib)):
    print('No file {}',(file_calib))
    exit()

print(file_lut, file_calib)



def GetCalib(file_name):
    calib_dic = []
    with open('{}'.format(file_name),'r') as fin:
        for line in fin:
            if not line:
                continue
            if line[0] == '#':
                continue
            line = line.split()
            # print(line)
            calib_list = {'domain':0, 'pol_list':[]}
            calib_dom = []
            index = 0;
            calib_list['domain'] = line[0]
            for index in range(1, len(line)):
                calib_list['pol_list'].append(float(line[index]))
            # print(calib_list)
            calib_dic.append(calib_list)
    calib_json = json.dumps(calib_dic, indent=3)
    # with open('{}.json'.format(file_name.split('.')[0]), 'w') as fout:
    #     fout.write(calib_json)
    return calib_json

def GetLUTFromTxt(file_name):
    lut_dic = []
    with open('{}'.format(file_name),'r') as fin:
        for line in fin:
            if line[0] == '#':
                continue

            lut_line = line.split()
            if not lut_line :
                continue

            time_offset_pulser = {0:0, 1:34.9093, 2:54.008, 3:72.7227, 4:91.4133, 5:110.203, 6:129.128, 7:147.84, 8:162.589, 9:181.272, 10:200.384, 11:219.077, 12:237.659, 13:256.515, 14:275.355, 15:293.944, 16:312.979, 17:331.859, 18:350.368, 19:369.184, 20:367.731, 21:402.48, 22:421.152, 23:431.869, 24:450.397, 25:469.219, 26:488.144, 27:506.829, 28:-114.608, 29:-95.8067}

            par_list = { 'channel':0, 'domain':0, 'detType':0, 'serial':0, 'TimeOffset':0, 'theta':0, 'phi':0,  'threshold':0, 'cs_dom':0, 'enable':0, 'pol_order':1, 'pol_list':[]}

            index = 0
            bl_found_pol_list = False

            for par in par_list:
                if par == 'pol_list' and not bl_found_pol_list:
                    bl_found_pol_list = True

                if bl_found_pol_list:
                    for i in range(index, len(lut_line)):
                        par_list[par].append(lut_line[i])
                elif par == 'serial':
                    par_list[par] = lut_line[index]
                elif par == 'TimeOffset':
                    par_list[par] = float(lut_line[index])
                else:
                    par_list[par] = int(lut_line[index])
                index+=1    
            # print(par_list)
            par_list['TimeOffset'] = time_offset_pulser[ par_list['channel']//100 ]
            par_list['on'] = 1
            lut_dic.append(par_list)
    lut_json = json.dumps(lut_dic, indent=3)
    print(lut_json)

    with open('{}.json'.format(file_name.split('.')[0]), 'w') as fout:
        fout.write(lut_json)

    return lut_json

def GetJSON_FILE(file_json):
    with open('{}'.format(file_json),'r') as fin:
        return json.load(fin)

def AddNewCalib(mylut, mycalib):
   print(mylut)
   for ch_lut in mylut:
       for ch_cal in mycalib:
           if int(ch_lut['domain'] )== int(ch_cal['domain']):
               ch_lut['pol_list'] = ch_cal['pol_list']
   # print(mylut)
   return  mylut

lut = GetLUTFromTxt(file_lut)
calib = GetCalib(file_calib)

# print(calib)

# lut = GetJSON_FILE(file_json)
# calib = GetJSON_FILE(file_calib_json)


if blModifyCalib:
    newlut = AddNewCalib(lut, calib)
    new_lut_json = json.dumps(newlut, indent=3)
    with open('{}_new.json'.format(file_lut.split('.')[0]), 'w') as fout:
        fout.write(new_lut_json)
else:
    with open('{}.json'.format(file_lut.split('.')[0]), 'w') as fout:
        fout.write(lut)

# print(newlut)
