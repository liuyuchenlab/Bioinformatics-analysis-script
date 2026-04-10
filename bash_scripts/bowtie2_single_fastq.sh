ls *fastq|cut -d"_" -f 1|sort -u |while read id;do
bowtie2 -p 10 -x /disk5/lyc/index/mouse/bowtie2_mm10/mm10 -U ${i}.fastq | samtools sort -O bam -@ 10 -o - > bowtie2/${i}.sorted.bam;
done
