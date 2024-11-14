#! /usr/bin/python3

import json
import sys
from os.path import exists

# file_lut = 'LUT_ELIADE_S9_20230623_RUN68_152Eu.json'
file_lut = 'LUT_RECALL_S9_20240604.json'

def file_exists(myfile):
    if not exists(myfile):
        print('file_exists: File {} does not exist'.format(myfile))
        return False
    print('file_exists: File found {}'.format(myfile))
    return True

def GetJSON_FILE(file_json):
    if file_exists(file_json):
        with open('{}'.format(file_json),'r') as fin:
            return json.load(fin)

def UpdateFiledsFitLimits(js):
    for el in js:
        el['fitLimits'] = [200,800]
    return  js

def UpdateFiledsDomain(js):
    for el in js:
        if (el['domain'] >= 601 and el['domain'] <= 610):
            el['serial'] = 'CL31B'
        elif (el['domain'] >= 611 and el['domain'] <= 620):
            el['serial'] = 'CL31G'
        elif (el['domain'] >= 621 and el['domain'] <= 630):
            el['serial'] = 'CL31R'
        elif (el['domain'] >= 631 and el['domain'] <= 640):
            el['serial'] = 'CL31W'
        elif (el['domain'] >= 801 and el['domain'] <= 810):
            el['serial'] = 'CL36B'
        elif (el['domain'] >= 811 and el['domain'] <= 820):
            el['serial'] = 'CL36G'
        elif (el['domain'] >= 821 and el['domain'] <= 830):
            el['serial'] = 'CL36R'
        elif (el['domain'] >= 831 and el['domain'] <= 840):
            el['serial'] = 'CL36W'
        elif (el['domain'] >= 101 and el['domain'] <= 110):
            el['serial'] = 'CL29B'
        elif (el['domain'] >= 111 and el['domain'] <= 120):
            el['serial'] = 'CL29G'
        elif (el['domain'] >= 121 and el['domain'] <= 130):
            el['serial'] = 'CL29R'
        elif (el['domain'] >= 131 and el['domain'] <= 140):
            el['serial'] = 'CL29W'
        elif (el['domain'] >= 501 and el['domain'] <= 510):
            el['serial'] = 'CL34B'
        elif (el['domain'] >= 511 and el['domain'] <= 520):
            el['serial'] = 'CL34G'
        elif (el['domain'] >= 521 and el['domain'] <= 530):
            el['serial'] = 'CL34R'
        elif (el['domain'] >= 531 and el['domain'] <= 540):
            el['serial'] = 'CL34W'
        elif (el['domain'] >= 900 and el['domain'] <= 904):
            el['serial'] = 'CeBr'
            el['detType'] = 3

        # if el['serial'] != 'pulser':
        #     el['on'] = 0
#            el['detType'] = 9
#        else:
#            el['on'] = 0
    return js

def PrintFileds(js):
    print('channel','domain','threshold', 'on', 'serial', 'TimeOffset')
    i = 1
    for el in js:
       if (el['serial'][:-1]) == 'CL36':
       # if (el['domain'] >=600 and el['domain'] <700 ):
        # if el['on'] == 1:
        #      print(i,' ' ,el['channel'], ' ',el['domain'], ' ', el['serial'], el['threshold'], ' ', el['on'], el['TimeOffset'])
           print(i, el['domain'], ' ', el['serial'])
            # i+=1

original_js = GetJSON_FILE(file_lut)
PrintFileds(original_js)
#
# updated_js = json.dumps(UpdateFiledsDomain(original_js), indent=3)
updated_js = json.dumps(UpdateFiledsFitLimits(original_js), indent=3)
# # PrintFileds(updated_js)
with open('{}_new.json'.format(file_lut.split('.')[0]), 'w') as fout:
    fout.write(updated_js)
js = GetJSON_FILE('{}_new.json'.format(file_lut.split('.')[0]))
#PrintFileds(js)
















#
#    # updated_js = UpdateFileds(original_js)
#
#    with open('{}.json'.format(file_lut.split('.')[0]), 'w') as fout:
#        fout.write(updated_js)

# if __name__ == "__main__":
#    print('Convert DAT to JSON')
#    if (len(sys.argv) > 2):
#        file_lut = sys.argv[1]
#
#    if (not file_lut):
#        print('No file {}', (file_lut))
#        exit()
#
#    print('{} ---> {}.json'.format(file_lut, file_lut.split('.')[0]))
#
#    original_js = GetJSON_FILE(file_lut)
#    updated_js = json.dumps(UpdateFileds(original_js), indent=3)
#
#    # updated_js = UpdateFileds(original_js)
#
#    with open('{}.json'.format(file_lut.split('.')[0]), 'w') as fout:
#        fout.write(updated_js)
#
#    # main()

