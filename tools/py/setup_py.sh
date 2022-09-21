#!/bin/bash


my_home=$HOME

echo $my_home

echo /usr/local/bin/lut.print
sudo unlink /usr/local/bin/lut.print
echo $my_home/onlineEliade/tools/py/lut_print.py
sudo ln -s ~/onlineEliade/tools/py/lut_print.py /usr/local/bin/lut.print

echo /usr/local/bin/lut.json
sudo unlink /usr/local/bin/lut.json
echo $my_home/onlineEliade/tools/py/lut_to_json.py
sudo ln -s ~/onlineEliade/tools/py/lut_to_json.py /usr/local/bin/lut.json
