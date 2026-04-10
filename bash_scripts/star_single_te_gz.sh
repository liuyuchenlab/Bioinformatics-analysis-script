# 先创建输出目录（避免STAR报错，若te目录已存在可跳过）
mkdir -p mm39_te

# 批量处理 .fq.gz 压缩文件的STAR比对脚本
ls *.fq.gz | cut -d"." -f 1 | sort -u | while read id; do 
  STAR --runThreadN 20  --quantMode TranscriptomeSAM GeneCounts   --genomeDir /sc/lyc/index/mouse/rsem/mm39_TE/  --twopassMode Basic   --readFilesIn ${id}.fq.gz  --readFilesCommand zcat  --outSAMstrandField intronMotif  --outSAMtype BAM SortedByCoordinate  --alignEndsType EndToEnd  --outFileNamePrefix mm39_te/${id}
done
