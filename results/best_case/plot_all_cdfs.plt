set term pdf enhanced color linewidth 2 font "Helvetica,14"

set style line 1 lc rgb "#0060ad" lt 1 lw 1 pt 2 ps 1
set style line 2 lc rgb "#00796B" lt 1 lw 1 pt 2 ps 1
set style line 3 lc rgb "#8BC34A" lt 1 lw 1 pt 2 ps 1
set style line 4 lc rgb "#F4511E" lt 1 lw 1 pt 2 ps 1
set style line 5 lc rgb "#F88967" lt 1 lw 1 pt 2 ps 1
set style line 6 lc rgb "#BC3409" lt 1 lw 1 pt 2 ps 1

# in order to prepare the data (assuming single column of latencies):
# xsv select 2 raw/... | sort -n | uniq --count | awk 'BEGIN{sum=0}{print $2,$1,sum; sum=sum+$1}' > parsed.dat

set xlabel "Completion Time (ms)"
set ylabel "Complementary CDF"
set xrange [1:10000]
set logscale x 10
set logscale y 10
set format x "10^{%L}"
set format y "10^{%L}"

set key inside left bottom Left reverse

set output "out/all_cdfs.pdf"

stats "join.dat" using 3;
stats "join_2.dat" using 3;
stats "hector.dat" using 3; 

plot "join.dat" using 1:(1-$3/STATS_max) ls 2 with lines title "Join I",\
     "join_2.dat" using 1:(1-$3/STATS_max) ls 3 with lines title "Join II",\
     "hector.dat" using 1:(1-$3/STATS_max) ls 4 with lines title "WCO",\
