
for i in *.sam ; do i=${i%.sam*}; samtools sort  ${i}.sam > ${i}.bam -@ 20 ;done
for i in *.bam ; do i=${i%.bam*}; samtools sort  ${i}.bam > ../sorted/${i}.bam -@ 20 ;done
for i in *.bam ; do i=${i%.bam*}; samtools index ${i}.bam -@ 20 ;done

