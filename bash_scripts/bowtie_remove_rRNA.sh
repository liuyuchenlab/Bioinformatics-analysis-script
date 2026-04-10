mkdir remove_rRNA_tRNA
for i in *.fq;do
bowtie2 -x /sc/lyc/index/mouse/bowtie2_rRNA_tRNA/mm39 --un remove_rRNA_tRNA/${i} -U ${i}  -p 40 -S ${i}_rRNA.sam; rm ${i}_rRNA.sam;
done

