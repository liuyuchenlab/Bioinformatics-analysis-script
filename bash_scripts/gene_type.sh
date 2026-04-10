#!/bin/bash
# 功能：从GTF文件中筛选指定gene_type的gene行
# 用法：sh filter_gene_type.sh <输入GTF文件> <目标gene_type>
# 示例：sh filter_gene_type.sh gencode.vM38.chr_patch_hapl_scaff.annotation.gtf rRNA

# ======================== 参数校验 ========================
# 检查参数数量是否为2个
if [ $# -ne 2 ]; then
    echo -e "\033[31m错误：参数数量错误！\033[0m"
    echo -e "正确用法：$0 <输入GTF文件路径> <要筛选的gene_type（如rRNA/mRNA/tRNA）>"
    echo -e "示例：$0 gencode.vM38.chr_patch_hapl_scaff.annotation.gtf rRNA"
    exit 1
fi

# 定义变量（提升可读性）
INPUT_GTF="$1"       # 第一个参数：输入GTF文件
TARGET_TYPE="$2"     # 第二个参数：目标gene_type（如rRNA）
OUTPUT_GTF="${TARGET_TYPE}.gtf"  # 输出文件：目标类型.gtf（如rRNA.gtf）

# ======================== 文件检查 ========================
# 检查输入文件是否存在
if [ ! -f "$INPUT_GTF" ]; then
    echo -e "\033[31m错误：输入文件 $INPUT_GTF 不存在！\033[0m"
    exit 1
fi

# 检查输入文件是否为空
if [ ! -s "$INPUT_GTF" ]; then
    echo -e "\033[31m错误：输入文件 $INPUT_GTF 为空文件！\033[0m"
    exit 1
fi

# ======================== 核心筛选 ========================
echo -e "\033[32m开始筛选 gene_type 为 [${TARGET_TYPE}] 的gene行...\033[0m"
# 使用awk筛选：-v传参避免字符串拼接问题，兼容特殊字符
awk -v target="$TARGET_TYPE" '
    $3 == "gene" && $0 ~ "gene_type \"" target "\""
' "$INPUT_GTF" > "$OUTPUT_GTF"

# ======================== 结果校验 ========================
# 检查筛选命令是否执行成功
if [ $? -eq 0 ]; then
    # 统计筛选出的行数
    LINE_COUNT=$(wc -l < "$OUTPUT_GTF")
    echo -e "\033[32m筛选完成！\033[0m"
    echo -e "输入文件：$INPUT_GTF"
    echo -e "目标gene_type：$TARGET_TYPE"
    echo -e "输出文件：$OUTPUT_GTF"
    echo -e "筛选出的行数：$LINE_COUNT"
else
    echo -e "\033[31m错误：筛选过程失败！\033[0m"
    exit 1
fi
