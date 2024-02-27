This the manual how to use HDTV. Hope to grow on united efforts:


TERMINAL


Open file:
s g mDelila_raw_py_109.spe

Fitting
fit parameter status
fit list
fit write test.txt
fit d all
fit read test.txt
fit peakfind -a -t 0.1
fit parameter background 3 #3 stands for poly

Calibration 
calibration position nuclide -s 0 -d IAEA Eu-152



Normalization (at least 2 spectra are needed)
spectrum normalize 0 10


Export spectrum:
print file.pdf -y "counts" -x "energy"


##GUI
