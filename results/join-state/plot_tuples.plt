set term pdf enhanced color linewidth 2 font "Helvetica,14"

set style line 1 lc rgb "#0060ad" lt 1 lw 1 pt 2 ps 1
set style line 2 lc rgb "#00796B" lt 1 lw 1 pt 2 ps 1
set style line 3 lc rgb "#8BC34A" lt 1 lw 1 pt 2 ps 1
set style line 4 lc rgb "#F4511E" lt 1 lw 1 pt 2 ps 1
set style line 5 lc rgb "#F88967" lt 1 lw 1 pt 2 ps 1
set style line 6 lc rgb "#BC3409" lt 1 lw 1 pt 2 ps 1

set boxwidth 0.5

set style fill solid
set style data histograms
set style histogram rowstacked
set style fill solid 1.0 border -1

set xlabel "Arity"
set ylabel "Arranged Tuples"

set key inside left top Left reverse

set yrange [0:180000]

set output "out/tuples_join.pdf"
plot "tuples_join.dat" using 2 ls 3 title "Base Relations", \
     "" using 3:xticlabels(1) ls 5 title "Intermediate Arrangements", \

set output "out/tuples_delta.pdf"
plot "tuples_delta.dat" using 2 ls 3 title "Base Relations", \
     "" using 3:xticlabels(1) ls 5 title "Intermediate Arrangements", \
