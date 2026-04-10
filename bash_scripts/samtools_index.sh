for i in *Aligned.sortedByCoord.out.bam  ; do i=${i%Aligned.sortedByCoord.out.bam *}; samtools index ${i}  -@ 128 ;done


