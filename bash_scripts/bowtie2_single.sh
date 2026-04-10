mkdir bowtie2
ls *.fq|cut -d"." -f 1|sort -u |while read id;do
bowtie2 -p 40 -k 10 -x /sc/lyc/index/mouse/bowtie2/mm39 -U ${id}.fq | samtools sort -O bam -@ 10 -o - > bowtie2/${id}.sorted.bam;
done
