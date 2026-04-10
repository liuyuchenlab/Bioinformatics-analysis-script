#fastq-dump  --split-files  ./*.sra -O fq/      
# 使用12个线程，输出压缩的FASTQ文件，并正确处理双端或10X Genomics数据
parallel-fastq-dump --sra-id ./*.sra --threads 1 --outdir ./fq/ --split-files --gzip     
