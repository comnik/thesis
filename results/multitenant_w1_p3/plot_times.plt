set datafile separator ","
set term pdf enhanced color linewidth 2 font "Helvetica,14"
set output "times.pdf"

set style line 1 lc rgb "#0060ad" lt 1 lw 1 pt 7 ps 1
set style line 2 lc rgb "#00796B" lt 1 lw 1 pt 7 ps 1
set style line 3 lc rgb "#8BC34A" lt 1 lw 1 pt 7 ps 1
set style line 4 lc rgb "#F4511E" lt 1 lw 1 pt 7 ps 1

set title "Per-Epoch Latencies"
set xlabel "Epoch"
set ylabel "Completion Time (ms)"

plot "./times_shared_nothing.csv" using 0:1 ls 1 title "Shared Nothing" with lines, \
     "./times_interests.csv" using 0:1 ls 2 title "Shared Everything" with lines, \
     "./times_multitenant.csv" using 0:1 ls 3 title "Multi-Tenant" with lines
