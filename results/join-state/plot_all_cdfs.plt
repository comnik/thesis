set term pdf enhanced color linewidth 2 font "Helvetica,14"

set style line 1 lc rgb "#0060ad" lt 1 lw 1 pt 2 ps 1
set style line 2 lc rgb "#00796B" lt 1 lw 1 pt 2 ps 1
set style line 3 lc rgb "#8BC34A" lt 1 lw 1 pt 2 ps 1
set style line 4 lc rgb "#F4511E" lt 1 lw 1 pt 2 ps 1
set style line 5 lc rgb "#F88967" lt 1 lw 1 pt 2 ps 1
set style line 6 lc rgb "#BC3409" lt 1 lw 1 pt 2 ps 1

# in order to prepare the data (assuming single column of latencies):
# xsv select 2 raw/... | sort -n | uniq -c | awk 'BEGIN{sum=0}{print $2,$1,sum; sum=sum+$1}' > parsed.dat

set xlabel "Completion Time (ms)"
set ylabel "Complementary CDF"
set logscale x 10
set logscale y 10
set format x "10^{%L}"
set format y "10^{%L}"

set xrange [1:100]

set key inside left bottom Left reverse

set output "out/all_cdfs.pdf"

stats "join_3.dat" using 3;
stats "join_5.dat" using 3;
stats "join_7.dat" using 3;
stats "delta_3.dat" using 3;
stats "delta_5.dat" using 3;
stats "delta_7.dat" using 3;

plot "join_3.dat" using 1:(1-$3/STATS_max) ls 1 with lines title "3-Join",\
     "join_5.dat" using 1:(1-$3/STATS_max) ls 2 with lines title "5-Join",\
     "join_7.dat" using 1:(1-$3/STATS_max) ls 3 with lines title "7-Join",\
     "delta_3.dat" using 1:(1-$3/STATS_max) ls 4 with lines title "3-Delta",\
     "delta_5.dat" using 1:(1-$3/STATS_max) ls 5 with lines title "5-Delta",\
     "delta_7.dat" using 1:(1-$3/STATS_max) ls 6 with lines title "7-Delta",\
