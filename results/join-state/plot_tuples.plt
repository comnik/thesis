set term pdf enhanced color linewidth 2 font "Helvetica,14"

set style line 1 lc rgb "#0060ad" lt 1 lw 1 pt 2 ps 1
set style line 2 lc rgb "#00796B" lt 1 lw 1 pt 2 ps 1
set style line 3 lc rgb "#8BC34A" lt 1 lw 1 pt 2 ps 1
set style line 4 lc rgb "#F4511E" lt 1 lw 1 pt 2 ps 1
set style line 5 lc rgb "#F88967" lt 1 lw 1 pt 2 ps 1
set style line 6 lc rgb "#BC3409" lt 1 lw 1 pt 2 ps 1

set boxwidth 0.5
set style fill solid

set xlabel "Arity"
set ylabel "Arranged Tuples"

set xrange [1:8]
set yrange [0:100000]

set output "out/tuples_join.pdf"
plot "tuples.dat" using 1:2 ls 1 with boxes notitle

set output "out/tuples_delta.pdf"
plot "tuples.dat" using 1:3 ls 3 with boxes notitle
