#!/bin/bash

# 配置参数
DOWNLOAD_DIR="./ENA"
TSV_FILE=$(find . -maxdepth 1 -name "*tsv" -o -name "filereport*" | head -n1)
STATS_FILE="download_stats.txt"

# 创建下载目录
mkdir -p "$DOWNLOAD_DIR"

# 1.自动查找当前目录下的TSV文件
if [[ -z "$TSV_FILE" ]]; then
    echo "❌ 错误: 未找到TSV文件"
    exit 1
fi
echo "使用TSV文件: $TSV_FILE"

# 2.提取fastq_ftp列中的所有FTP链接，并转换为完整URL
awk -F'\t' '
NR==1 { for(i=1;i<=NF;i++) if($i=="fastq_ftp") col=i }
NR>1 && $col { split($col, urls, ";"); for(u in urls) print "ftp://" urls[u] }
' "$TSV_FILE" > url_list.txt

# 统计总链接数
TOTAL_LINKS=$(wc -l < url_list.txt)
echo "发现 $TOTAL_LINKS 个下载链接"

# 3.逐个下载文件
echo "开始下载文件..."
SUCCESS_COUNT=0
FAILED_COUNT=0

while read url; do
    if [[ -n "$url" ]]; then
        filename=$(basename "$url")
        echo "下载中: $filename"
        
        if wget -c -t 3 -q "$url" -P "$DOWNLOAD_DIR"; then
            echo "成功: $filename"
            ((SUCCESS_COUNT++))
        else
            echo "失败: $filename"
            ((FAILED_COUNT++))
        fi
    fi
done < url_list.txt

# 4.在下载循环结束后，显示简要统计结果
echo -e "\n=== 下载完成 ==="
echo "总链接数: $TOTAL_LINKS"
echo "成功下载: $SUCCESS_COUNT"
echo "失败数量: $FAILED_COUNT"
