
#!/bin/bash

# 检查CSV文件是否存在
CSV_FILE="rename.csv"
if [ ! -f "$CSV_FILE" ]; then
    echo "CSV 文件 $CSV_FILE 不存在。"
    exit 1
fi

# 逐行读取CSV文件
while IFS=, read -r old_prefix new_prefix
do
    # 移除行末的回车字符并去除引号
    old_prefix=$(echo "$old_prefix" | tr -d '\r' | tr -d '"')
    new_prefix=$(echo "$new_prefix" | tr -d '\r' | tr -d '"')
    
    # 查找所有匹配旧前缀的文件
    for old_filename in ${old_prefix}_*.fq.gz; do
        # 检查文件是否存在
        if [ -f "$old_filename" ]; then
            # 构建新的文件名
            suffix=${old_filename#${old_prefix}}  # 提取后缀，例如 "_f1.fq.gz" 或 "_r2.fq.gz"
            new_file="${new_prefix}${suffix}"
            
            # 进行重命名操作
            mv "$old_filename" "$new_file"
            echo "重命名 $old_filename 为 $new_file"
        else
            echo "文件 $old_filename 不存在，跳过。"
        fi
    done
done < "$CSV_FILE"

echo "批量重命名操作完成。"
