#!/bin/bash

# 设置参考基因组路径 (请根据实际情况修改)
REFERENCE=/sc/lyc/index/mouse/cellranger/GRCm39 # 例如 /home/user/refdata-gex-GRCh38-2020-A

# 设置FASTQ文件所在目录 (默认为当前目录，如果FASTQ文件在其他目录，请修改)
FASTQ_DIR=./

# 设置输出目录 (cellranger结果输出目录)
OUTPUT_DIR="./cellranger_output"

# 从符合 *_S1_L001_I1_001.fastq.gz 的文件名中提取样品名
# 样品名定义为 _S1 前面的部分
sample_names=()
while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    # 提取样品名 (假设样品名是 _S1 之前的部分)
    sample_name="${filename%%_S1*}"
    # 添加到数组，如果尚未添加
    if [[ ! " ${sample_names[@]} " =~ " ${sample_name} " ]]; then
        sample_names+=("$sample_name")
    fi
done < <(find "$FASTQ_DIR" -maxdepth 1 -name "*_S1_L001_I1_001.fastq.gz" -print0)

# 检查是否找到样品
if [ ${#sample_names[@]} -eq 0 ]; then
    echo "错误: 在目录 $FASTQ_DIR 中未找到匹配 *_S1_L001_I1_001.fastq.gz 的文件"
    exit 1
fi

# 显示找到的样品
echo "找到以下样品:"
printf '%s\n' "${sample_names[@]}"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 生成并运行 cellranger count 命令
for sample in "${sample_names[@]}"; do
    echo "处理样品: $sample"
    
    # 运行 cellranger count
    cellranger count \
        --id="$sample" \
        --transcriptome="$REFERENCE" \
        --fastqs="$FASTQ_DIR" \
        --sample="$sample" \
        --localcores=8 

    # 将结果移动到输出目录
    if [ -d "$sample" ]; then
        mv "$sample" "$OUTPUT_DIR/"
        echo "已将 $sample 的结果移动到 $OUTPUT_DIR/"
    fi
done

echo "所有样品处理完成!"
