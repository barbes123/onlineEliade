#! /usr/bin/python3
import os
import subprocess
import json
import datetime

class TMeasurement:
    def __init__(self, server, run, source, tstart, tstop, distance):
        self.run = run
        self.source = source
        self.tstart = tstart
        self.tstop = tstop
        self.server = server
        self.distance = distance


    def __str__(self):
        return print('Server {}, Run: {}, Source: {}, Time Start: {}, Time Stop: {}'.format(self.server, self.run, self.source, self.tstart, self.tstop))

    def dump(self):
        return {'server':self.server, 'run':self.run, 'source': self.source, 'tstart': self.tstart, 'tstop': self.tstop, 'distance': self.distance}

class TIsotope:
    def __init__(self, name, t12, date0, a0):
        self.name = name
        self.t12 = t12*365*24*3600
        self.date0 = date0
        self.a0 = a0

    def dump(self):
        return {'name': self.name, 't12': self.t12, 'date': self.date0, 'a0': self.a0}


my_run1 = TMeasurement('0','run01','152Eu',datetime.datetime(2022,8,21,8,0,0),datetime.datetime(2022,8,21,11,0,0),'0')
my_run2 = TMeasurement('0','run02','252Cf',datetime.datetime(2022,7,21,8,0,0),datetime.datetime(2022,8,1,11,0,0),'0')
my_run12345 = TMeasurement('3','run12345','60Co',datetime.datetime(2022,7,26,11,33,31),datetime.datetime(2022,7,26,13,20,17),'0')

my_runs = [my_run1, my_run2, my_run12345]

json_runs = json.dumps([src.dump() for src in my_runs], indent=4, default=str)
print(json_runs)

with open('run_table_template.json','w') as of:
    of.write('{ \n "measurements":')
    of.write(json_runs)
    of.write('\n}')


print(my_run1.__str__())

iso152Eu = TIsotope('152Eu',13.537,datetime.datetime(2015,9,9,12,0,0),543.5e3)
iso60Co = TIsotope('60Co',5.2714,datetime.datetime(2015,9,9,12,0,0),92.27e3)
iso252Cf = TIsotope('252Cf',2.645,datetime.datetime(2021,3,21,12,0,0),36.02e3)

my_sources = [iso60Co, iso152Eu, iso252Cf]
i_my_source = iter(my_sources)
# print("List of available sources")
# while True:
#     try:
#         source_item = next(i_my_source)
#         # json_sources = json.dumps(source_item.__dict__, indent=2, sort_keys=True, default=str)
#         print(source_item.__str__())
#     except StopIteration:
#         break



json_sources = json.dumps([src.dump() for src in my_sources], indent=3, default=str)
with open('sources.json','w') as infile:
    infile.write('{ \n "sources":')
    infile.write(json_sources)
    infile.write('\n}')



# subprocess.call('/home/dumon/EliadeSorting/EliadeTools/RecalEnergy')