#/usr/bin/python3

import json

fileJson = 'LUT_RECALL_RUN144.json'

with open('{}'.format(fileJson),'r') as fjson:
    js_data =json.load(fjson)


print(js_data)


for datum in js_data:
    datum['PTLimits'] = [0,10000]
    if datum['detType'] == 2:
        datum['fitLimits'] = [400,1200]
        datum['ampl'] = [100]

new_js_data = json.dumps(js_data, indent=3)

with open('new_{}'.format(fileJson),'w') as foutjson:
    foutjson.write(new_js_data)