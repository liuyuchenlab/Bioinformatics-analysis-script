for i in *.sorted.bam;do
	bamCoverage -bs 100 --normalizeUsing CPM -of bedgraph -b ${i} -o bedgraph/${i}.bedgraph;
done
