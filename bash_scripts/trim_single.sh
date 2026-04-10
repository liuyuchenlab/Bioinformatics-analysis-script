for fq in *.fq.gz; do
  echo "开始修剪：$fq"
  nohup trim_galore -q 25 --phred33 --length 36 --stringency 3 -j 40 -o trim/ "$fq" >> trim_galore.log 2>&1
  echo "完成修剪：$fq"
done
