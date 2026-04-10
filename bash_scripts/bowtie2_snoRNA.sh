mkdir bowtie2
ls *.fq|cut -d "_" -f 1|sort -u |while read id;do
bowtie2 -p 40  --very-sensitive-local --no-mixed --no-discordant  -x /sc/lyc/index/mouse/bowtie2/mm39 -1 ${id}_1.fq -2 ${id}_2.fq | samtools sort -O bam -@ 40 -o - > bowtie2/${id}.sorted.bam;
done
#
#
