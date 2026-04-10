mkdir -p bowtie2
ls *.fq | cut -d "_" -f 1 | sort -u | parallel -j 10 \
  "bowtie2 -p 4 -k 10 --end-to-end --very-sensitive --no-mixed --no-discordant --phred33 -I 10 -X 700 \
  -x /sc/lyc/index/mouse/bowtie2/mm39 \
  -1 {}\_1.fq -2 {}\_2.fq \
  | samtools sort -O bam -@ 4 -o bowtie2_k10/{}.sorted.bam -"
