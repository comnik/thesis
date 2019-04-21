set term pdf enhanced color linewidth 2 font "Helvetica,14"

set style line 1 lc rgb "#0060ad" lt 1 lw 1 pt 2 ps 1
set style line 2 lc rgb "#00796B" lt 1 lw 1 pt 2 ps 1
set style line 3 lc rgb "#8BC34A" lt 1 lw 1 pt 2 ps 1
set style line 4 lc rgb "#F4511E" lt 1 lw 1 pt 2 ps 1

set xlabel "Completion Time (ms)"
set ylabel "Complementary CDF"
set logscale x 10
set logscale y 10
set format x "10^{%L}"
set format y "10^{%L}"

set output "out/batch_cdf.pdf"

stats "batch/join.dat" using 3;
stats "batch/dogs.dat" using 3;

plot "batch/join.dat" using 1:(1-$3/STATS_max) ls 3 with lines title "Join ([a c] [b c]) [a b]",\
     "batch/dogs.dat" using 1:(1-$3/STATS_max) ls 4 with lines title "WCO", 
