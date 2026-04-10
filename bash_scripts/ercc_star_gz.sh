ls *gz|cut -d"_" -f 1|sort -u |while read id;do 
STAR --runThreadN 20 --quantMode TranscriptomeSAM GeneCounts --genomeDir /sc/lyc/index/ercc92/ercc_mm39  --twopassMode Basic --readFilesCommand gunzip -c --readFilesIn ${id}_R1.fq.gz ${id}_R2.fq.gz --outSAMtype BAM SortedByCoordinate --outSAMstrandField intronMotif --outFileNamePrefix  ercc_mm39/${id}
done

