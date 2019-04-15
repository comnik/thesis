set term pdf enhanced color linewidth 2 font "Helvetica,14"

set style line 1 lc rgb "#0060ad" lt 1 lw 1 pt 2 ps 1
set style line 2 lc rgb "#00796B" lt 1 lw 1 pt 2 ps 1
set style line 3 lc rgb "#8BC34A" lt 1 lw 1 pt 2 ps 1
set style line 4 lc rgb "#F4511E" lt 1 lw 1 pt 2 ps 1
set style line 5 lc rgb "#F88967" lt 1 lw 1 pt 2 ps 1
set style line 6 lc rgb "#BC3409" lt 1 lw 1 pt 2 ps 1

# in order to prepare the data (assuming single column of latencies):
# cat data | sort -n | uniq --count | awk 'BEGIN{sum=0}{print $2,$1,sum; sum=sum+$1}' > parsed.dat

set xlabel "Completion Time (ms)"
set ylabel "Percentile"
set logscale x 10
set logscale y 10
set format x "10^{%L}"
set format y "10^{%L}"

set key inside left bottom Left reverse

set output "out/all_cdfs.pdf"

stats "nobatch/join_ab_ac_bc.dat" using 3;
stats "nobatch/join_ab_bc_ac.dat" using 3;
stats "nobatch/join_ac_bc_ab.dat" using 3;
stats "nobatch/dogs_ab_bc_ac.dat" using 3;
stats "nobatch/dogs_ab_ac_bc.dat" using 3;
stats "nobatch/dogs_bc_ac_ab.dat" using 3;

plot "nobatch/join_ab_ac_bc.dat" using 1:(1-$3/STATS_max) ls 1 with lines title "Join ([a b] [a c]) [b c]",\
     "nobatch/join_ab_bc_ac.dat" using 1:(1-$3/STATS_max) ls 2 with lines title "Join ([a b] [b c]) [a c]",\
     "nobatch/join_ac_bc_ab.dat" using 1:(1-$3/STATS_max) ls 3 with lines title "Join ([a c] [b c]) [a b]",\
     "nobatch/dogs_ab_ac_bc.dat" using 1:(1-$3/STATS_max) ls 5 with lines title "Hector I",\
     "nobatch/dogs_ab_bc_ac.dat" using 1:(1-$3/STATS_max) ls 4 with lines title "Hector II",\
     "nobatch/dogs_bc_ac_ab.dat" using 1:(1-$3/STATS_max) ls 6 with lines title "Hector III"
