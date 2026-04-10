mkdir tecounts ;
for i in *Aligned.sortedByCoord.out.bam; do i=${i%*Aligned.sortedByCoord.out.bam*};
TEcount --sortByPos --format BAM --mode multi -b ${i}Aligned.sortedByCoord.out.bam --GTF /sc/lyc/index/mouse/ref/mm39.ncbiRefSeq.gtf --TE /sc/lyc/index/mouse/ref/mm39_rmsk_TE.gtf  --project tecounts/${i};
done
