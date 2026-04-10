ls *fq|cut -d"_" -f 1|sort -u |while read id;do 
STAR --runThreadN 20 --quantMode TranscriptomeSAM GeneCounts --genomeDir /sc/lyc/index/mouse/star/mm39/  --twopassMode Basic  -c --readFilesIn ${id}_1.fq ${id}_2.fq --outSAMstrandField intronMotif --outSAMtype BAM SortedByCoordinate --outFileNamePrefix star/${id}
done

