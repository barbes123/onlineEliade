# necessary classes, functions to calculate activity
from datetime import datetime
import numpy as np
import math


time_format = "%Y-%m-%d %H:%M:%S"

class TIsotope:
    def __init__(self, name, t12, date0, a0):
        self.name = name
        self.t12 = t12*365*24*3600
        self.date0 = date0
        self.a0 = a0

    def setup_source_from_json(self, data, source_name):
        self.found = False
        for source in data['sources']:
            if source['name'] == source_name:
                self.name = source['name']
                self.date0 = datetime.strptime(source['date'], time_format)
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
    def __init__(self, server, run, source, tstart, tstop, distance):
        self.run = run
        self.source = source
        self.tstart = tstart
        self.tstop = tstop
        self.server = server
        self.distance = distance
        self.found = True

    def setup_run_from_json(self, data, val, server):
        self.found = False
        for runnbr in data['measurements']:
            if ((int(runnbr['run']) == int(val)) and (int(runnbr['server']) == int(server))):
                # self.source = runnbr['source']
                if (self.found):
                    print('Multiple occurrence in run {} and server {}'.format(runnbr, server))
                    sys.exit()
                self.run = runnbr['run']
                self.tstart = datetime.strptime(runnbr['tstart'],time_format)
                self.tstop = datetime.strptime(runnbr['tstop'],time_format)
                self.found = True
            if runnbr['source'] is None:
               runnbr['source'] = '60Co'
            else:
                self.source = runnbr['source']
                # print("{}, YES".format(val))

    def __str__(self):
        return print('Run: {}, Server: {}, Source: {}, Time Start: {}, Time Stop: {} Found {}'.format(self.run, self.server, self.source, self.tstart, self.tstop, self.found))
