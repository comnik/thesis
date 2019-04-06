set term pdf enhanced color linewidth 2 font "Helvetica,14"

set style line 1 lc rgb "#0060ad" lt 1 lw 1 pt 2 ps 1
set style line 2 lc rgb "#00796B" lt 1 lw 1 pt 2 ps 1
set style line 3 lc rgb "#8BC34A" lt 1 lw 1 pt 2 ps 1
set style line 4 lc rgb "#F4511E" lt 1 lw 1 pt 2 ps 1

set xlabel "Completion Time (ms)"
set ylabel "Percentile"
set logscale x 10

set output "out/extended_cdf.pdf"

stats "extended/join_ac_bc_ab.dat" using 3;
stats "extended/dogs.dat" using 3;

plot "extended/join_ac_bc_ab.dat" using 1:(1-$3/STATS_max) ls 1 with lines title "Join ([a c] [b c]) [a b]",\
     "extended/dogs.dat" using 1:(1-$3/STATS_max) ls 2 with lines title "DogsDogsDogs", 
