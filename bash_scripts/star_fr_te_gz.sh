ls *fq.gz|cut -d"_" -f 1|sort -u |while read id;do 
STAR --runThreadN 20 --quantMode TranscriptomeSAM GeneCounts --genomeDir /sc/lyc/index/mouse/rsem/mm39_TE/ --twopassMode Basic --readFilesCommand gunzip -c --readFilesIn ${id}_f1.fq.gz ${id}_r2.fq.gz --outSAMtype BAM SortedByCoordinate --outSAMstrandField intronMotif --outFileNamePrefix  mm39_te/${id}
done

