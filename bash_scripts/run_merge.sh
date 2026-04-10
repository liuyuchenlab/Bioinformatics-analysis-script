#!/bin/bash

# 获取符合格式的所有 _f1 文件
files_f1=$(ls *-*-*_f1.fq.gz 2>/dev/null)

# 获取符合格式的所有 _r2 文件
files_r2=$(ls *-*-*_r2.fq.gz 2>/dev/null)

# 如果没有符合格式的 _f1 文件，提示并退出
if [ -z "$files_f1" ] && [ -z "$files_r2" ]; then
  echo "没有符合格式的 _f1 或 _r2 文件，脚本结束！"
  exit 1
fi

# 获取所有符合格式的编号（无论是 _f1 还是 _r2 文件）
# 这里我们通过提取文件名的A和B部分来分组
nums=$(echo "$files_f1 $files_r2" | tr ' ' '\n' | sed -E 's/^(.*-.*)-([0-9]+)-[0-9]+_.*\.fq.gz/\1-\2/' | sort -n | uniq)

# 循环处理每个编号
for i in $nums; do
  # 获取符合当前编号的所有 _f1 文件
  current_files_f1=$(echo "$files_f1" | grep -E ".*${i}-.*_f1.fq.gz")
  # 获取符合当前编号的所有 _r2 文件
  current_files_r2=$(echo "$files_r2" | grep -E ".*${i}-.*_r2.fq.gz")

  # 如果当前编号没有符合格式的 _f1 或 _r2 文件，跳过该编号
  if [ -z "$current_files_f1" ] && [ -z "$current_files_r2" ]; then
    echo "编号 $i 没有符合格式的 _f1 或 _r2 文件，跳过。"
    continue
  fi

  # 输出当前处理的编号
  echo "正在处理编号: $i"

  # 处理 _f1 文件
  if [ ! -z "$current_files_f1" ]; then
    echo "找到以下 _f1 文件："
    echo "$current_files_f1"
    # 合并 _f1 文件并生成带有组号的文件名（文件名格式 A-B_f1.fq.gz）
    output_f1="${i}_f1.fq.gz"
    echo "$current_files_f1" | xargs cat > "$output_f1"
    echo "已创建新文件：$output_f1"
    rm $current_files_f1
    echo "已删除原 _f1 文件"
  fi

  # 处理 _r2 文件
  if [ ! -z "$current_files_r2" ]; then
    echo "找到以下 _r2 文件："
    echo "$current_files_r2"
    # 合并 _r2 文件并生成带有组号的文件名（文件名格式 A-B_r2.fq.gz）
    output_r2="${i}_r2.fq.gz"
    echo "$current_files_r2" | xargs cat > "$output_r2"
    echo "已创建新文件：$output_r2"
    rm $current_files_r2
    echo "已删除原 _r2 文件"
  fi
done

echo "处理完成！"

