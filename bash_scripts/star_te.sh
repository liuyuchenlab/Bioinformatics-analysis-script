ls *fq|cut -d"_" -f 1|sort -u |while read id;do 
STAR --runThreadN 20 --quantMode TranscriptomeSAM GeneCounts --genomeDir /sc/lyc/index/mouse/rsem/mm39_TE/  --twopassMode Basic  -c --readFilesIn ${id}_1.fq ${id}_2.fq --outSAMstrandField intronMotif --outSAMtype BAM SortedByCoordinate --outFileNamePrefix te/${id}
done

