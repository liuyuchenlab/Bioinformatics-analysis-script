#!/bin/bash
# 功能：从GTF文件中提取指定转座子家族的注释，并生成BED文件
# 用法：./extract_te_family.sh -f <家族名称> -i <输入.gtf> [-o 输出目录]

# 参数解析与默认值
FAMILY=""       # 必选参数：目标转座子家族名称
INPUT_GTF=""    # 必选参数：输入GTF文件路径
OUTPUT_DIR="."  # 可选参数：输出目录（默认为当前目录）

# 解析命令行参数（支持长选项）
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--family) 
            FAMILY="$2"
            shift ;;
        -i|--input) 
            INPUT_GTF="$2"
            shift ;;
        -o|--output-dir) 
            OUTPUT_DIR="$2"
            shift ;;
        -h|--help)
            echo "Usage: $0 -f <family_name> -i <input.gtf> [-o output_dir]"
            echo "Example: $0 -f MERVL-int -i input.gtf -o ./bed_files"
            exit 0 ;;
        *) 
            echo "未知参数: $1"
            exit 1 ;;
    esac
    shift
done

# 检查必填参数
if [[ -z "$FAMILY" || -z "$INPUT_GTF" ]]; then
    echo "错误：必须提供 -f 和 -i 参数！"
    exit 1
fi

# 检查输入文件是否存在
if [[ ! -f "$INPUT_GTF" ]]; then
    echo "错误：输入文件 $INPUT_GTF 不存在！"
    exit 1
fi

# 创建输出目录（若不存在）
mkdir -p "$OUTPUT_DIR"

# 定义输出文件名（家族名.bed）
OUTPUT_BED="${OUTPUT_DIR%/}/${FAMILY}.bed"

# 提取目标家族并转换格式
grep "family_id\s*\"${FAMILY}\"" "$INPUT_GTF" | \
awk -F'\t' 'BEGIN {OFS="\t"} {print $1, $4-1, $5, $9, $6, $7}' > "$OUTPUT_BED"

# 检查是否成功生成文件
if [[ -s "$OUTPUT_BED" ]]; then
    echo "成功生成文件：$OUTPUT_BED"
else
    echo "警告：未找到家族 '$FAMILY' 的注释！"
    rm -f "$OUTPUT_BED"  # 删除空文件
    exit 2
fi
