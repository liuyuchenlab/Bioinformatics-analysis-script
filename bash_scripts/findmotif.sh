#!/bin/bash

# 遍历所有 TXT 文件
for file in *.txt; do
    # 提取文件名（不带扩展名）
    base_name=$(basename "$file" .txt)
    
    # 创建输出目录
    output_dir="${base_name}/"
    mkdir -p "$output_dir"
    
    # 运行 findMotifs.pl
    findMotifs.pl "$file" mouse "$output_dir" -start -2000 -end 100 -len 8,10,12 -p 40
done

