#bash
mkdir bamcompare;
for i in *.bam ;do
	bamCompare --normalizeUsing RPKM  -b1 ${i} -b2 L2C.bam --scaleFactorsMethod None  -p 40 -o bamcompare/${i%.bam}.bw;
done 
