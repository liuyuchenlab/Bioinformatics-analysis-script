#没有control数据如下处理
for i in *.bam
do 
macs2 callpeak -f BAMPE -t $i -n ${i%.bam} -g mm  --nolambda --nomodel --keep-dup all -p 0.05  --outdir macs2 
done
