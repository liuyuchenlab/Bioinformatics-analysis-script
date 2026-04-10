mkdir seqkit_20
for i in *.fq.gz ; do i=${i%.fq*};seqkit subseq -r 21:-1 -j 40 ${i}.fq.gz -o seqkit_20/${i}.fq.gz ;done
