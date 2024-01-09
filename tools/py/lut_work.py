import json

fileJson ='LUT_ELIADE_S9_20230526_RUN63.json'

with open('{}'.format(fileJson),'r') as fjson:
    js_data =json.load(fjson)

for element in js_data:
    if element['detType'] == 2:
        element['on'] = 0

new_js_data = json.dumps(js_data, indent=3)

with open('new_{}'.format(fileJson),'w') as foutjson:
    foutjson.write(new_js_data)

