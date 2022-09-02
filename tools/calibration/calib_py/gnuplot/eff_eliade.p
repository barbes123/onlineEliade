set xrange [99:120]   
set yrange [0:0.01] #0.1 for cores  
set size 0.95, 0.95
set bmargin 5
set lmargin 12

set term eps
set output 'eliade_efficiency_all.eps'

set title "Clover (ELIADE) efficiency"

set xtics font ",14"
set xtics 100,10,150
set ytics font ",14"  
set grid xtics mxtics ytics mytics 
#set grid #xtics mxtics ytics mytics back# ls 12, ls 13

set encoding iso_8859_1 
set xlabel "Domain" font ",16" offset 0,-1
# set xlabel " "
# set ylabel " "
set ylabel "Efficiency, %" font ",16" offset -2,0

set style line 1 linecolor rgb '#ff0000' linetype 2 linewidth 3 
set style line 110 linecolor '#black' linetype 2 linewidth 2 dt 3 pointtype 7 pointsize .5 

set style line 112 linecolor '#black' linetype 1 linewidth 3 
set style line 114 linecolor rgb '#ff8040' linetype 2 linewidth 1 dt 3 pointtype 9 pointsize 2.5 
#set logscale x
#set xtics format " " 
#set xtics (10, 100, 1000)
#set xtics autofreq

#set label 1 at 13, 15
#set label 1 '(b)' font ",18" tc '#black'

set key font ",10" at 106.0, .09
#set nokey
plot 'resolution_1173.txt'  using 1:10 linestyle 110  lc 1 title "1173 keV",\
     'resolution_1332.txt'  using 1:10 linestyle 110  lc 2 title "1332 keV", \
     'resolution_661.txt'  using 1:10 linestyle 110  lc 3 title "661 keV", \
     'resolution_344.txt'  using 1:10 linestyle 110  lc 3 title "344 keV", \
     'resolution_411.txt'  using 1:10 linestyle 110  lc 4 title "411 keV", \
     'resolution_444.txt'  using 1:10 linestyle 110  lc 5 title "444 keV", \
     'resolution_778.txt'  using 1:10 linestyle 110  lc 6 title "778 keV", \
     'resolution_964.txt'  using 1:10 linestyle 110  lc 7 title "964 keV", \
     'resolution_1085.txt'  using 1:10 linestyle 110  lc 8 title "1085 keV", \
     'resolution_1112.txt'  using 1:10 linestyle 110  lc 9 title "1112 keV", \
     'resolution_1408.txt'  using 1:10 linestyle 110  lc 10 title "1408 keV", \
     'resolution_1274.txt'  using 1:10 linestyle 110  lc 11  title "1274 keV" 
