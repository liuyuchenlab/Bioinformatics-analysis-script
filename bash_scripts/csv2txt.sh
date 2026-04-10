#!/bin/bash

for file in *.csv; do
    # 使用 tr 命令替换逗号为制表符（或其他分隔符）
    tr ',' '\t' < "$file" > "${file%.csv}.txt"
done

