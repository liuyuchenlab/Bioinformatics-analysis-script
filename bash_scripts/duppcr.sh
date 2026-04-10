#!/bin/bash
# 脚本名称：dedup_sambamba.sh
# 功能：用sambamba批量去重（速度比Picard快30倍）

input_dir="./"
output_dir="dupdelete"
mkdir -p "$output_dir"

# 并行处理（根据服务器CPU调整线程数）
parallel_jobs=10

find "$input_dir" -name "*.bam" | parallel -j $parallel_jobs \
  "sambamba markdup -r -t 40 --overflow-list-size=600000 {} $output_dir/\$(basename {})" 
