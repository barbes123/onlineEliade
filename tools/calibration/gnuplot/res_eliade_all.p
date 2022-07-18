set size 0.95, 0.95
set xrange [90:150]  
set yrange [1:10]  
set bmargin 5
set lmargin 12

set term eps
set output 'eliade_res_'.ENER.'_keV.eps'

set title 'Clover (ELIADE) resolution'.ENER.' kev'

set xtics font ",14"
set xtics 100,10,150
set ytics font ",14"  
set grid xtics mxtics ytics mytics 
#set grid #xtics mxtics ytics mytics back# ls 12, ls 13

set encoding iso_8859_1 
set xlabel "Domain" font ",16" offset 0,-1
# set xlabel " "
# set ylabel " "
set ylabel "Resolution, keV" font ",16" offset -2,0

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

set key font ",14" at 240.0, 9.
#set nokey
plot 'resolution_'.ENER.'.txt'  using 1:6 linestyle 110  linecolor rgb '#0000FF' title ''.ENER.'keV'

