mkdir tecounts ;
for i in *.sorted.bam; do i=${i%*.sorted.bam*};
TEcount --sortByPos --format BAM --mode multi -b ${i}.sorted.bam --GTF /sc/lyc/index/mouse/ref/mm39.ncbiRefSeq.gtf --TE /sc/lyc/index/mouse/ref/mm39_rmsk_TE.gtf  --project tecounts/${i};
done
