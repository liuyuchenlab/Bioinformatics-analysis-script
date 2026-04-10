#!/bin/bash
# 脚本名称：filter_bam.sh
# 功能：批量过滤MAPQ≥20的比对结果

# 输入目录（存放 *.sorted.bam 文件）
input_dir="./"
# 输出目录
output_dir="filtered"
mkdir -p "$output_dir"

# 并行处理（根据服务器CPU调整线程数）
parallel_jobs=1

# 使用find遍历所有sorted.bam文件并过滤
find "$input_dir" -name "*.bam" | parallel -j $parallel_jobs \
  "samtools view -h -q 20  {} | \
  samtools sort -@ 10 -O BAM -o $output_dir/\$(basename {} .bam).bam -"
