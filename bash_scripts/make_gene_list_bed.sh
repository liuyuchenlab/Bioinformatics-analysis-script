#!/bin/bash
# 脚本功能：从BED文件中提取指定基因列表的行
# 用法：./extract_genes.sh <基因列表文件> <BED文件> <输出文件>

# 检查参数数量
if [ $# -ne 3 ]; then
    echo "错误：参数不足。用法：$0 <基因列表文件> <BED文件> <输出文件>"
    echo "示例：$0 minorZGA.txt mm39_gene_fixed.bed minorZGA.bed"
    exit 1
fi

gene_list="$1"
bed_file="$2"
output_file="$3"

# 第一步：转换基因列表文件格式（处理Windows换行符）
echo "正在转换文件格式：dos2unix $gene_list"
dos2unix "$gene_list" 2>/dev/null || {
    echo "警告：dos2unix命令未安装，尝试跳过换行符转换"
    # 若dos2unix不可用，尝试用sed替代
    sed -i 's/\r$//' "$gene_list" || {
        echo "错误：无法处理换行符，请手动安装dos2unix或检查文件权限"
        exit 1
    }
}

# 第二步：提取匹配基因的行
echo "正在提取基因数据：$gene_list → $bed_file → $output_file"
awk 'NR==FNR {genes[$1]; next} $4 in genes' "$gene_list" "$bed_file" > "$output_file" || {
    echo "错误：awk执行失败，请检查输入文件格式"
    exit 1
}

# 验证输出
if [ -s "$output_file" ]; then
    echo "成功生成输出文件：$output_file（行数：$(wc -l < "$output_file")）"
else
    echo "警告：输出文件为空，请检查基因列表与BED文件的匹配性"
fi
