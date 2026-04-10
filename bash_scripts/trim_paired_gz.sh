ls *.fq.gz |xargs -n 2 -t nohup trim_galore -q 25 --phred33 --length 36 --stringency 3 --paired -j 40  -o trim/ &
