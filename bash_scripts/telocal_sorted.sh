mkdir telocal
for i in *.sorted.bam;do  base_name=${i%.sorted.bam};
	TElocal --sortByPos -b $i	--GTF  /sc/lyc/index/mouse/ref/mm39.ncbiRefSeq.gtf  --TE /sc/lyc/index/mouse/telocal/mm39_rmsk_TE.gtf.locInd  --project telocal/${base_name} ;
done
