# 创建输出目录（若不存在）
 mkdir -p fastqc

 # 生成双端文件名配对列表
 ls *_1.fq.gz > 1
 ls *_2.fq.gz > 2
 paste 1 2 > config

# # 并行运行FastQC
 cat config | while read line; do
     arr=($line)
         R1=${arr[0]}
             R2=${arr[1]}
                 nohup fastqc -t 40 $R1 $R2 -o fastqc &
                 done
