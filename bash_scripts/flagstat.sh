for i in *.bam ; do i=${i%.bam*}; samtools flagstat ${i}.bam > ${i}.txt -@ 40 ;done

