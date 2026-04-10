mkdir tecounts ;
for i in *.sort.bam; do i=${i%*.sort.bam*};
TEcount --sortByPos --format BAM --mode multi -b ${i}.sort.bam --GTF /sc/lyc/index/mouse/ref/mm39.ncbiRefSeq.gtf --TE /sc/lyc/index/mouse/ref/mm39_rmsk_TE.gtf  --project tecounts/${i};
done

