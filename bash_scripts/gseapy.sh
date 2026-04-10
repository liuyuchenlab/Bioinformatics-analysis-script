#!/bin/bash

# 搜索当前目录下的所有 CSV 文件
for csv_file in *.csv; do
    # 获取 CSV 文件的基本名称
    csv_base_name=$(basename "$csv_file" .csv)

    # 搜索当前目录下的所有 GMT 文件
    for gmt_file in *.gmt; do
        # 获取 GMT 文件的基本名称
        gmt_base_name=$(basename "$gmt_file" .gmt)

        # 创建一个以 CSV 文件名和 GMT 文件名组合命名的文件夹
        output_dir="${csv_base_name}_${gmt_base_name}"
        mkdir -p "$output_dir"

        # 运行 gseapy prerank 命令
        gseapy prerank -r "$csv_file" -g "$gmt_file" -p 10  -o "$output_dir/"  --min-size 1 --max-size 15000
    done
done

