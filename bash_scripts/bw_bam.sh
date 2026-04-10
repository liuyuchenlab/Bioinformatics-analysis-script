#bash
mkdir bw_rpkm;
for i in *.bam ;do
	bamCoverage --normalizeUsing RPKM  -b ${i} -p 40 -o bw_rpkm/${i%.bam}.bw;
done 
