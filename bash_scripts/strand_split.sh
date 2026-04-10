for i in *Aligned.sortedByCoord.out.bam ; do i=${i%Aligned.sortedByCoord.out.bam*}; 
#foward
samtools view -@ 128 -b -f 128 -F 16 ${i}Aligned.sortedByCoord.out.bam  > ${i}.f1.bam
samtools view -@ 128 -b -f 80 ${i}Aligned.sortedByCoord.out.bam > ${i}.f2.bam
#reVERSE
samtools view -@ 128 -b -f 144 ${i}Aligned.sortedByCoord.out.bam > ${i}.r1.bam
samtools view -@ 128 -b -f 64 -F 16 ${i}Aligned.sortedByCoord.out.bam > ${i}.r2.bam
#merge
samtools merge -@ 128 -f ${i}.f.bam ${i}.f1.bam ${i}.f2.bam
samtools merge -@ 128 -f ${i}.r.bam ${i}.r1.bam ${i}.r2.bam
#index
samtools index ${i}.f.bam -@ 128
samtools index ${i}.r.bam -@ 128
#bamCoverage
bamCoverage -b ${i}.f.bam -o ${i}.f.bw -p 128
bamCoverage -b ${i}.r.bam -o ${i}.r.bw -p 128
done

