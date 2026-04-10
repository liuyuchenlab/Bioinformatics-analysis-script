mkdir rsem_te;for i in *Aligned.toTranscriptome.out.bam ; do i=${i%Aligned.toTranscriptome.out.bam*};
rsem-calculate-expression --paired-end -no-bam-output --alignments -p 128    ${i}Aligned.toTranscriptome.out.bam  /sc/lyc/index/human/rsem/te/hg38  rsem_te/${i} ;
done

