#! /usr/bin/python3
import os, json

with open('LUT_RECALL_S1_CL29_152Eu.json','r') as ifile:
    js_data = json.load(ifile)


for el in js_data:
    el['fitLimits'] = [80,1500]
    el['amp'] = 1000
    el['PTLimits'] = [0, 1500]

js_new_data = json.dumps(js_data, indent=3)

with open('LUT_RECALL_S1_CL29_152Eu.json','w') as ofile:
    ofile.write(js_new_data)