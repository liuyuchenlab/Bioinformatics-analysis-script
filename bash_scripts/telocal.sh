mkdir telocal
for i in *Aligned.sortedByCoord.out.bam;do  base_name=${i%Aligend.sortedByCoord.out.bam};
	TElocal --sortByPos -b $i	--GTF  /sc/lyc/index/mouse/ref/mm39.ncbiRefSeq.gtf  --TE /sc/lyc/index/mouse/telocal/mm39_rmsk_TE.gtf.locInd  --project telocal/${base_name} ;
done
