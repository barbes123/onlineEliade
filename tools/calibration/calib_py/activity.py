#! /usr/bin/python3
import os.path
import sys, getopt
from pathlib import Path
from os.path import exists #check if file exists
from datetime import datetime
import json

from libCalib import TIsotope as TIso
from libCalib import TMeasurement as Tmeas



data_folder = '{}/onlineEliade/tools/calibration/calib_py/data'.format(Path.home())
source_file= 'sources.json'
data_file= 'run_table.json'
time_format = "%Y-%m-%d %H:%M:%S"

def file_exists(myfile):
    if not exists(myfile):
        print('File {} does not exist'.format(myfile))
        sys.exit()
    print('File found {}'.format(myfile))
    return True

def main(argv):
   sfile = '{}/{}'.format(data_folder,source_file)
   dfile = '{}/{}'.format(data_folder,data_file)
   run_nbr = 0
   serverID = 0
   opts, args = getopt.getopt(argv,"hi:o:",["source_file=","data_file=","run=","id="])
   for opt, arg in opts:
      if opt == '-h':
         print ('ndecays.py -s <json source file> -d <json data file> -r <run number> -id <server ID>')
         print('if not provided defaults are: {}'.format(sfile))
         print('if not provided defaults are: {}'.format(dfile))
         print('if not provided default run is: {}'.format(run_nbr))
         print('if not provided default Server ID is: {}'.format(serverID))
         sys.exit()
      elif opt in ("-s", "--sfile"):
         sfile = arg
      elif opt in ("-d", "--dfile"):
         dfile = arg
      elif opt in ("-id", "--id"):
         serverID = arg
      elif opt in ("-r","--run"):
          run_nbr = arg

   print('input parameters')
   print('json data file: {}'.format(dfile))
   print('json radioactive source file file: {}'.format(sfile))
   print('run number: {}'.format(run_nbr))
   print('server number {}'.format(serverID))

   file_exists(sfile)
   file_exists(dfile)

   with open('{}'.format(sfile), 'r') as my_source_file:
       j_sourses = json.load(my_source_file)
   with open('{}'.format(dfile), 'r') as my_data_file:
       j_data = json.load(my_data_file)

   # Looking for run information
   my_run = Tmeas('', '', '', datetime.strptime('2022-08-08 12:00:00', time_format), datetime.strptime('2022-08-08 12:00:00', time_format), 0)
   my_run.setup_run_from_json(j_data, int(run_nbr), int(serverID))
   if my_run.found:
        my_run.__str__()
   else:
       print('The run {} information on server {} is missing in json {} '.format(run_nbr, serverID, dfile))
       sys.exit()

   #Looking for source information
   # my_source = TIso('', 0, datetime.strptime('2022-08-08 00:00:00', time_format), 0)


   my_source = TIso('','','',0)
   my_source.setup_source_from_json(j_sourses, my_run.source)
   if my_source.found:
       # print('I found the source {} in sources.json'.format(my_source.name))
       my_source.__str__()
       print('Number of decays:', round(my_source.GetNdecays(my_run.tstart, my_run.tstop)))
   else:
       print('The source {} was not found in sources.json'.format(my_source.name))
       sys.exit()



if __name__ == "__main__":
   main(sys.argv[1:])
