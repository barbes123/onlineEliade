#! /usr/bin/python3

import json
import sys
from os.path import exists

file_lut = 'LUT_ELIADE_S9_pulser.json'

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

def UpdateFileds(js):
    for el in js:
        if el['serial'] == 'pulser':
            el['on'] = 1
            el['detType'] = 9
        else:
            el['on'] = 0
    return js

def PrintFileds(js):
    i = 1
    for el in js:
        if el['serial'] == 'pulser':
            print(i,' ' ,el['channel'], ' ',el['domain'], ' ',el['threshold'])
            i+=1
    return js

original_js = GetJSON_FILE(file_lut)
PrintFileds(original_js)

updated_js = json.dumps(UpdateFileds(original_js), indent=3)
# PrintFileds(updated_js)
with open('{}_new.json'.format(file_lut.split('.')[0]), 'w') as fout:
    fout.write(updated_js)

js = GetJSON_FILE('{}_new.json'.format(file_lut.split('.')[0]))

PrintFileds(js)
















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

