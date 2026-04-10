mkdir rsem;for i in *Aligned.toTranscriptome.out.bam ; do i=${i%Aligned.toTranscriptome.out.bam*};
rsem-calculate-expression --paired-end -no-bam-output --alignments -p 128    ${i}Aligned.toTranscriptome.out.bam  /sc/lyc/index/mouse/rsem/mm39/mm39  rsem/${i} ;
done

