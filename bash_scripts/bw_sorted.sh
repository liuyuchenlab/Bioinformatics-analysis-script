#bash
mkdir bw_rpkm;
for i in *.sorted.bam ;do 
	bamCoverage --normalizeUsing RPKM  -b ${i} -p 40 -o bw_rpkm/${i%.sorted.bam}.bw;
done 
