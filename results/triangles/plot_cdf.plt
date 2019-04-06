# set datafile separator ","
set term pdf enhanced color linewidth 2 font "Helvetica,14"

set style line 1 lc rgb "#0060ad" lt 1 lw 1 pt 2 ps 1
set style line 2 lc rgb "#00796B" lt 1 lw 1 pt 2 ps 1
set style line 3 lc rgb "#8BC34A" lt 1 lw 1 pt 2 ps 1
set style line 4 lc rgb "#F4511E" lt 1 lw 1 pt 2 ps 1

set xlabel "Completion Time (ms)"
set ylabel "Percentile"
set logscale x 10

set output "out/cdf.pdf"

stats "nobatch/join_ab_bc_ac.dat" using 3;
stats "nobatch/dogs_ab_bc_ac.dat" using 3;

plot "nobatch/join_ab_bc_ac.dat" using 1:(1-$3/STATS_max) ls 1 with lines title "JoinJoinJoin",\
     "nobatch/dogs_ab_bc_ac.dat" using 1:(1-$3/STATS_max) ls 2 with lines title "DogsDogsDogs", 