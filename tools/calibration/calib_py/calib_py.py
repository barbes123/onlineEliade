#! /usr/bin/python3
import numpy as np
import math
# import datetime
from datetime import datetime
from scipy.integrate import quad
import json
import os
import sys
import shutil #copy files
from os.path import exists #check if file exists
import subprocess #run external script

time_format = "%Y-%m-%d %H:%M:%S"

class TIsotope:
    def __init__(self, name, t12, date0, a0):
        self.name = name
        self.t12 = t12*365*24*3600
        self.date0 = date0
        self.a0 = a0

    def setup_source_from_json(self, data, source_name):
        self.found = False
        # time_format = "%Y-%m-%d %H:%M:%S"
        for source in data['sources']:
            if source['name'] == source_name:
                self.name = source['name']
                self.date0 = datetime.strptime(source['date'], time_format)
                # self.date0 =source['date']
                self.a0 = source['a0']
                self.t12 = source['t12']*365*24*3600
                self.found = True

    def decay_constant(self):
        return math.log(2, math.e)/self.t12

    def __repr__(self):
        return print('Isotope: {}, T12= {} s, Date {}, A0 = {}'.format(self.name, self.t12, self.date0, self.a0))

    def __str__(self):
        return print('Isotope: {}, T12= {} s, Date {}, A0 = {}'.format(self.name, self.t12, self.date0, self.a0))

    def Activity(self, time1):
        t = time1 - self.date0
        # print('Activity after {} s is {} Bq'.format(t.total_seconds(), self.a0*np.exp(-1*self.decay_constant()*t.total_seconds())))
        return self.a0 * np.exp(-1 * self.decay_constant() * t.total_seconds())

    def GetNdecays(self, start, stop):
        return(1 / 2 * (self.Activity(start) + self.Activity(stop)) * (stop - start).total_seconds())

class TMeasurement:
    def __init__(self, server, run, source, tstart, tstop):
        self.run = run
        self.source = source
        self.tstart = tstart
        self.tstop = tstop
        self.server = server
        self.found = True

    def setup_run_from_json(self, data, val):
        self.found = False
        # time_format = "%Y-%m-%d %H:%M:%S"
        for runnbr in data['measurements']:
            if runnbr['run'] == val:
                self.source = runnbr['source']
                self.run = runnbr['run']
                self.tstart = datetime.strptime(runnbr['tstart'],time_format)
                self.tstop = datetime.strptime(runnbr['tstop'],time_format)
                self.found = True
                # print("{}, YES".format(val))

    def __str__(self):
        return print('Run: {}, Source: {}, Time Start: {}, Time Stop: {} Found {}'.format(self.run, self.source, self.tstart, self.tstop, self.found))

def swap_first_line(file, newline):
    if not os.path.exists(file):
        print('File {} does not exists'.format(file))
        return
    shutil.copy(file, 'tempcp.txt')
    with open(file, 'r') as fread:
        fread.readline()
        with open("tempcp.txt", 'w') as fw:
            fw.write('{} \n'.format(newline))
            shutil.copyfileobj(fread, fw)
    shutil.copy('tempcp.txt', file)
    os.remove('tempcp.txt')

my_run = TMeasurement('0','xxx','152Eu',datetime.strptime('2022-08-08 12:00:00', time_format), datetime.strptime('2022-08-21 11:00:00', time_format))
my_source = TIsotope('152Eu',13.537,datetime.strptime('2015-9-9 12:00:00', time_format),543.5e3)

#starting the processes

with open('data/run_table.json','r') as ifile:
    j_runs = json.load(ifile)


domain_start = 109
domain_stop = 109
# reading inline parameters
if (len(sys.argv) > 1):
    # print(sys.argv[1])
    my_run.setup_run_from_json(j_runs,sys.argv[1])
    # print(my_run.__str__())
    if my_run.found:
        # print(my_run.__str__())
        print('I found {} in run_table.json'.format(sys.argv[1]))
    else:
        print('I not found the run {} in run_table.json'.format(sys.argv[1]))
        sys.exit()

if (len(sys.argv) == 3):
    domain_start = sys.argv[2]
    domain_stop = sys.argv[2]

if (len(sys.argv) == 4):
    domain_start = sys.argv[2]
    domain_stop = sys.argv[3]


with open('data/sources.json','r') as ifile:
    j_sourses = json.load(ifile)

my_source.setup_source_from_json(j_sourses, my_run.source)

if my_source.found:
    # print(my_source.__str__())
    print('I found the source {} in sources.json'.format(my_source.name))
else:
    print('The source {} was not found in sources.json'.format(my_source.name))
    sys.exit()

try:
    my_run
    # print(my_run.__str__())
except NameError:
    pass

# print('Ndecays {}'.format(my_source.GetNdecays(my_run.tstart, my_run.tstop)))

#---------------running run_calib.sh-------------------------------------------
if my_run.source == '252Cf':
    sys.exit()

list_of_sources = {'137Cs':0, '60Co':0, '22Na':0, '152Eu':0}

list_of_sources[my_run.source] = round(my_source.GetNdecays(my_run.tstart, my_run.tstop))

print('My source is {}, NDecays is {}'.format(my_run.source, list_of_sources[my_run.source]))

sh_script = 'run_calib_{}.sh'.format(my_run.run)

if not exists(sh_script):
    shutil.copy('run_calib.sh',sh_script)


#change limit for plotting in gnuplot
x1 = int(domain_start)-10
x2 = int(domain_stop)+10
swap_first_line('gnuplot/res_eliade.p','set xrange [{}:{}]  '.format(x1, x2))
swap_first_line('gnuplot/eff_eliade.p','set xrange [{}:{}]  '.format(x1, x2))

#run the bash script
run_params = './{}'.format(sh_script), str(domain_start), str(domain_stop),str(list_of_sources['137Cs']), str(list_of_sources['60Co']), str(list_of_sources['22Na']), str(list_of_sources['152Eu'])
print('I will run run_calib with run params {}'. format(run_params))
subprocess.call(['./{}'.format(sh_script), str(domain_start), str(domain_stop),str(list_of_sources['137Cs']), str(list_of_sources['60Co']), str(list_of_sources['22Na']), str(list_of_sources['152Eu'])])

print(domain_start)