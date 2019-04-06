# set datafile separator ","
set term pdf enhanced color linewidth 2 font "Helvetica,14"

set style line 1 lc rgb "#0060ad" lt 1 lw 1 pt 2 ps 1
set style line 2 lc rgb "#00796B" lt 1 lw 1 pt 2 ps 1
set style line 3 lc rgb "#8BC34A" lt 1 lw 1 pt 2 ps 1
set style line 4 lc rgb "#F4511E" lt 1 lw 1 pt 2 ps 1

set title "Latencies"
set xlabel "Completion Time (ms)"
set ylabel "Percentile"
set logscale x 10

set output "cdf.pdf"

stats "joinjoinjoin_parsed.dat" using 3;
stats "dogsdogsdogs_parsed.dat" using 3;

plot "joinjoinjoin_parsed.dat" using 1:(1-$3/STATS_max) ls 1 with lines title "JoinJoinJoin",\
     "dogsdogsdogs_parsed.dat" using 1:(1-$3/STATS_max) ls 2 with lines title "DogsDogsDogs", 