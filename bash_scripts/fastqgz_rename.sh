#!/bin/bash

# 查找当前目录下的第一个 .txt 文件
input_file=$(ls *.txt 2>/dev/null | head -n 1)

# 确保找到输入文件
if [[ -z $input_file ]]; then
  echo "没有找到 .txt 文件!"
  exit 1
fi

echo "使用文件: $input_file"

# 对输入文件中的旧文件名进行排序并重命名（适配fastq.gz，兼容单端/双端）
awk -F'\t' '
{
    # 保留SRR列（$1）和样本名列（$2），删除行名（默认处理，无额外操作）
    print $1 "\t" $2
}' "$input_file" | sort -k1,1 | while IFS=$'\t' read -r srr_name sample_name; do
    # 去除可能的Windows换行符（保留原有逻辑）
    srr_name=$(echo $srr_name | tr -d '\r')
    sample_name=$(echo $sample_name | tr -d '\r')

    # 定义双端文件名称（SRR_1.fastq.gz / SRR_2.fastq.gz）
    srr_1_fq="${srr_name}_1.fastq.gz"
    srr_2_fq="${srr_name}_2.fastq.gz"
    sample_1_fq="${sample_name}_1.fq.gz"
    sample_2_fq="${sample_name}_2.fq.gz"

    # 定义单端文件名称（SRR.fastq.gz）
    srr_single_fq="${srr_name}.fastq.gz"
    sample_single_fq="${sample_name}.fq.gz"

    # 第一步：判断是否为双端文件（优先处理双端，避免和单端冲突）
    if [[ -e $srr_1_fq && -e $srr_2_fq ]]; then
        # 重命名双端文件
        mv $srr_1_fq $sample_1_fq
        mv $srr_2_fq $sample_2_fq
        echo "重命名双端: $srr_1_fq -> $sample_1_fq; $srr_2_fq -> $sample_2_fq"
    # 第二步：判断是否为单端文件
    elif [[ -e $srr_single_fq ]]; then
        # 重命名单端文件
        mv $srr_single_fq $sample_single_fq
        echo "重命名单端: $srr_single_fq -> $sample_single_fq"
    # 第三步：文件不存在的提示
    else
        echo "文件不存在: 既无${srr_single_fq}（单端），也无${srr_1_fq}/${srr_2_fq}（双端）"
    fi
done
