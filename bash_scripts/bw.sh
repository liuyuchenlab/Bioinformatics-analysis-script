#bash
mkdir bw;
for i in *Aligned.sortedByCoord.out.bam ;do
	bamCoverage --normalizeUsing RPKM  -b ${i} -p 40 -o bw/${i%Aligned.sortedByCoord.out.bam}.bw;
done 
