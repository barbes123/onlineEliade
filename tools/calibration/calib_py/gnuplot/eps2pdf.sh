#!/bin/bash

run=${2:-$1}
clover=${1:-33}

cat eliade_resolution_all.eps | epstopdf --filter >1.pdf
cat eliade_efficiency_all.eps | epstopdf --filter >2.pdf
ofile="clover"$clover"_run"$run".pdf"
pdftk 1.pdf 2.pdf cat output "$ofile"

rm 1.pdf
rm 2.pdf
