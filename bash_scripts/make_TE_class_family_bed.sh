#!/bin/bash

# 参数检查
if [ $# -lt 3 ]; then
    echo "Usage: $0 <input.bed> -f <family_value> 或 $0 <input.bed> -c <class_value>"
    exit 1
fi

input_file="$1"
option="$2"
value="$3"
output_file=""

# 根据参数选择匹配字段
case "$option" in
    -f)
        output_file="${value}.bed"
        awk -F'\t'  '$10 ~ /family_id "'$value'"/' "$input_file" > "$output_file"
        ;;
    -c)
        output_file="${value}.bed"
        awk -F'\t'  '$10 ~ /class_id "'$value'"/' "$input_file" > "$output_file"
        ;;
    *)
        echo "错误: 无效选项，请使用 -f 或 -c"
        exit 1
        ;;
esac

echo "已生成文件: $output_file"
