mkdir bowtie2_new
ls *.fq.gz|cut -d"_" -f 1|sort -u |while read id;do
bowtie2 -p 40 -N 1  --local  --very-sensitive  --no-mixed --no-discordant --phred33 -I 10 -X 700 -k 10  -x /sc/lyc/index/mouse/bowtie2/mm39 -1 ${id}_1.fq.gz -2 ${id}_2.fq.gz | samtools sort -O bam -@ 40 -o - > bowtie2_new/${id}.bam;
done
