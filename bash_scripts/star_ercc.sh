ls *fq|cut -d"_" -f 1|sort -u |while read id;do 
STAR --runThreadN 20 --quantMode TranscriptomeSAM GeneCounts --genomeDir /sc/lyc/index/ercc92/ercc_mm39/  --twopassMode Basic  -c --readFilesIn ${id}_1.fq ${id}_2.fq --outSAMstrandField intronMotif --outSAMtype BAM SortedByCoordinate --outFileNamePrefix star_ercc/${id}
done

