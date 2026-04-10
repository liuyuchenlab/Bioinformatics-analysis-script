#!/bin/bash
# 功能：将GTF文件（所有特征行）转换为BED6格式（无feature筛选）
# 核心逻辑：
#   1. 跳过##开头的注释行，其余所有行均转换
#   2. GTF(1-based) → BED(0-based) 坐标自动转换
#   3. BED name列优先gene_name → gene_id → 特征+位置
# 用法：
#   基础用法：sh gtf2bed_no_filter.sh <输入GTF文件> [输出BED文件]
#   示例1：sh gtf2bed_no_filter.sh gencode.vM38.annotation.gtf
#   示例2：sh gtf2bed_no_filter.sh gencode.vM38.annotation.gtf all_features.bed

# ======================== 颜色定义 ========================
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
NC='\033[0m' # 恢复默认颜色

# ======================== 参数处理 & 校验 ========================
# 检查至少传入1个参数（输入GTF）
if [ $# -lt 1 ]; then
    echo -e "${RED}错误：参数数量不足！${NC}"
    echo -e "用法说明："
    echo -e "  $0 <输入GTF文件路径> [输出BED文件路径]"
    echo -e "示例："
    echo -e "  $0 gencode.vM38.annotation.gtf                # 输出 gencode.vM38.annotation.bed"
    echo -e "  $0 gencode.vM38.annotation.gtf all.bed        # 输出 all.bed"
    exit 1
fi

# 定义变量
INPUT_GTF="$1"
# 输出BED：未指定则自动替换/添加.bed后缀
if [ -n "$2" ]; then
    OUTPUT_BED="$2"
else
    OUTPUT_BED="${INPUT_GTF%.gtf}.bed"  # 替换.gtf后缀为.bed
    if [ "$OUTPUT_BED" = "$INPUT_GTF" ]; then  # 输入无.gtf后缀时，直接加.bed
        OUTPUT_BED="${INPUT_GTF}.bed"
    fi
fi

# 检查输入文件是否存在
if [ ! -f "$INPUT_GTF" ]; then
    echo -e "${RED}错误：输入文件 $INPUT_GTF 不存在！${NC}"
    exit 1
fi

# 检查输入文件是否为空
if [ ! -s "$INPUT_GTF" ]; then
    echo -e "${RED}错误：输入文件 $INPUT_GTF 为空文件！${NC}"
    exit 1
fi

# ======================== 核心转换逻辑 ========================
echo -e "${YELLOW}开始转换（无feature筛选，保留所有非注释行）：${NC}"
echo -e "  输入GTF：$INPUT_GTF"
echo -e "  输出BED：$OUTPUT_BED"
echo -e "  注意：GTF(1-based) → BED(0-based) 坐标已自动转换"

# awk核心转换：跳过注释行，处理所有非注释行
awk '
    BEGIN {
        FS="\t"; OFS="\t"  # 输入/输出分隔符为制表符
    }
    # 跳过##开头的注释行
    $0 ~ /^##/ { next }
    # 处理所有非注释行（无feature筛选）
    {
        # 1. 坐标转换：GTF起始位(第4列)减1 → BED起始位
        chromStart = $4 - 1
        chromEnd = $5
        
        # 2. Score列：GTF的.替换为0
        score = ($6 == ".") ? 0 : $6
        
        # 3. Name列：优先gene_name → gene_id → 特征+位置
        name = ""
        gene_id = ""
        # 拆分第9列属性（; 分隔）
        split($9, attrs, /; /);
        for (i in attrs) {
            # 提取gene_name
            if (attrs[i] ~ /^gene_name "/) {
                split(attrs[i], val, /"/);
                name = val[2];
            }
            # 提取gene_id（备用）
            if (attrs[i] ~ /^gene_id "/) {
                split(attrs[i], gid, /"/);
                gene_id = gid[2];
            }
        }
        # 兜底命名：无gene_name/gene_id则用 特征_染色体_起始_终止
        if (name == "") {
            name = (gene_id != "") ? gene_id : ($3 "_" $1 "_" chromStart "_" chromEnd)
        }
        
        # 输出BED6列：chrom, chromStart, chromEnd, name, score, strand
        print $1, chromStart, chromEnd, name, score, $7
    }
' "$INPUT_GTF" > "$OUTPUT_BED"

# ======================== 结果校验 ========================
if [ $? -eq 0 ]; then
    # 统计有效行数（跳过空行）
    BED_ROWS=$(grep -v "^$" "$OUTPUT_BED" | wc -l)
    echo -e "${GREEN}转换完成！${NC}"
    echo -e "  输出文件：$OUTPUT_BED"
    echo -e "  转换行数：$BED_ROWS 行（已跳过注释行）"
else
    echo -e "${RED}错误：转换过程失败！${NC}"
    # 清理空输出文件
    if [ -f "$OUTPUT_BED" ] && [ ! -s "$OUTPUT_BED" ]; then
        rm -f "$OUTPUT_BED"
    fi
    exit 1
fi
