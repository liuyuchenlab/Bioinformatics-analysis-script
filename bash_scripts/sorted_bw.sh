#bash
mkdir bw;
for i in *.sorted.bam ;do
	bamCoverage --normalizeUsing BPM -b ${i} -p 40 -o bw/${i}.bw;
done 
