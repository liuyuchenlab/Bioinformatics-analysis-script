ls *.fq|cut -d"." -f 1|sort -u |while read id;do 
STAR --runThreadN 20 --quantMode TranscriptomeSAM GeneCounts --genomeDir /sc/lyc/index/mouse/rsem/mm39_TE/ --twopassMode Basic     --readFilesIn ${id}.fq  --outSAMstrandField intronMotif  --outSAMtype BAM SortedByCoordinate --outFilterMismatchNmax 2 --alignEndsType EndToEnd  --outFileNamePrefix  te/${id}
done

