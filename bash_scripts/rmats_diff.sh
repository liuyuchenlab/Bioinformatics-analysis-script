#!/bin/bash

# 创建一个输出目录
mkdir -p extracted_events

# 循环遍历每个 _rmats 文件夹
for dir in *_rmats; do
    if [ -d "$dir" ]; then
        echo "Processing directory: $dir"
        
        # 循环遍历每种事件类型
        for event in SE MXE A3SS A5SS RI; do
            # 构建文件名
            input_file="${dir}/${event}.MATS.JC.txt"
            output_file="extracted_events/${dir}_${event}_significant_genes.txt"
            
            # 检查文件是否存在
            if [ -f "$input_file" ]; then
                # 获取列名对应的列号
                fdr_col=$(head -1 "$input_file" | awk '{for(i=1;i<=NF;i++) if($i=="FDR") print i}')
                diff_col=$(head -1 "$input_file" | awk '{for(i=1;i<=NF;i++) if($i=="IncLevelDifference") print i}')
                
                # 筛选 FDR 和 IncLevelDifference，基于列名的列号
                awk -v fdr_col="$fdr_col" -v diff_col="$diff_col" '
                    NR==1 || ($fdr_col < 0.05 && ($diff_col > 0.1 || $diff_col < -0.1))
                ' "$input_file" > "$output_file"
                
                echo "Extracted significant genes for $event to $output_file"
            else
                echo "$input_file not found in $dir."
            fi
        done
    fi
done

