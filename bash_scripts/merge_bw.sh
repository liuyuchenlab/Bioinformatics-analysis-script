#!/bin/bash
# 完全匹配你的示例：bigWigMerge 输入bw 输出bedGraph → 排序bedGraph → bedGraphToBigWig
# 极简版：当前文件夹运行，无多余配置

# ======================== 仅需确认这1项 ========================
CHROM_SIZES="/sc/lyc/index/mouse/ref/mm39.chrom.sizes"
# ==============================================================

# 检查工具
tools=("bigWigMerge" "bedGraphToBigWig" "sort")
for tool in "${tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "错误：未找到工具 $tool，请安装！"
        exit 1
    fi
done

# 检查chrom.sizes
if [ ! -f "$CHROM_SIZES" ]; then
    echo "错误：chrom.sizes文件不存在 → $CHROM_SIZES"
    exit 1
fi

# 创建输出目录
mkdir -p results/bedgraph results/bw results/tmp

# 按分组收集bw文件
declare -A GROUP_FILES
for bw_file in *.bw; do
    [ -f "$bw_file" ] || continue
    group=$(echo "$bw_file" | sed 's/-[0-9]\+\.bw$//g')
    if [ -z "${GROUP_FILES[$group]}" ]; then
        GROUP_FILES[$group]="$bw_file"
    else
        GROUP_FILES[$group]="${GROUP_FILES[$group]} $bw_file"
    fi
done

# 遍历分组执行（严格按你的示例顺序）
for GROUP in "${!GROUP_FILES[@]}"; do
    BW_LIST="${GROUP_FILES[$GROUP]}"
    RAW_BEDGRAPH="results/tmp/${GROUP}_raw.bedgraph"
    SORTED_BEDGRAPH="results/bedgraph/${GROUP}_sorted.bedgraph"
    FINAL_BW="results/bw/${GROUP}.bw"

    echo -e "\n===== 处理分组：$GROUP ====="
    # 步骤1：bigWigMerge（完全匹配你的示例：bw文件 → 输出bedGraph）
    echo "执行：bigWigMerge $BW_LIST $RAW_BEDGRAPH"
    bigWigMerge $BW_LIST $RAW_BEDGRAPH

    # 步骤2：排序bedGraph（bedGraphToBigWig必需）
    echo "执行：sort -k1,1 -k2,2n $RAW_BEDGRAPH > $SORTED_BEDGRAPH"
    sort -k1,1 -k2,2n "$RAW_BEDGRAPH" > "$SORTED_BEDGRAPH"

    # 步骤3：bedGraphToBigWig（匹配你的示例：排序bedGraph → chrom.sizes → 输出bw）
    echo "执行：bedGraphToBigWig $SORTED_BEDGRAPH $CHROM_SIZES $FINAL_BW"
    bedGraphToBigWig "$SORTED_BEDGRAPH" "$CHROM_SIZES" "$FINAL_BW"

    # 检查结果+清理临时文件
    if [ -s "$FINAL_BW" ]; then
        echo "✅ $GROUP 完成 → $FINAL_BW"
        rm -f "$RAW_BEDGRAPH"  # 删除未排序的临时bedgraph
    else
        echo "❌ $GROUP 失败！"
        rm -f "$RAW_BEDGRAPH" "$SORTED_BEDGRAPH" "$FINAL_BW"
    fi
done

# 清理临时目录（如果为空）
rmdir results/tmp 2>/dev/null

echo -e "\n📌 全部完成！最终文件在：$(pwd)/results/bw"
