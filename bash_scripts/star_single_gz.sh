# 先创建输出目录（避免STAR报错，若已存在可跳过）
mkdir -p mm39

# 批量处理 .fq.gz 文件的STAR比对脚本
ls *.fq.gz | cut -d"." -f 1 | sort -u | while read id; do 
  STAR --runThreadN 4 --limitBAMsortRAM 16000000000 --genomeLoad NoSharedMemory  --quantMode TranscriptomeSAM GeneCounts   --genomeDir /sc/lyc/index/mouse/star/mm39/   --twopassMode Basic  --readFilesIn ${id}.fq.gz  --readFilesCommand zcat    --outSAMstrandField intronMotif  --outSAMtype BAM SortedByCoordinate  --alignEndsType EndToEnd  --outFileNamePrefix mm39/${id}
done
