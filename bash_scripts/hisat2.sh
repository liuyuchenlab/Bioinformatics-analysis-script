mkdir hisat2bam|ls *gz|cut -d"_" -f 1|sort -u |while read i;do 
hisat2 --dta -x /sc/lyc/index/mouse/hisat2/mm39 --rna-strandness RF -1 ${i}_1.fq.gz -2 ${i}_2.fq.gz  -p 128 | samtools sort -@ 128 -o hisat2bam/${i}.sorted.bam
done

