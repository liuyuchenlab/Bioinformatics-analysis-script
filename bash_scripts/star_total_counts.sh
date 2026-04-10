#!/bin/sh

# 创建一个 CSV 文件并添加表头
output_file="star_total_counts.csv"
header="gene_id"

# 提取第一个文件的 gene_id 和 totalcounts 列
first_file=$(ls *ReadsPerGene.out.tab | head -n 1)
awk -v header="$header" 'NR > 3 {print $1 "," $2}' "$first_file" > "$output_file"

# 获取第一个文件的列名，并移除扩展名
first_file_name=$(basename "$first_file" ReadsPerGene.out.tab)
header="$header,$first_file_name"

# 提取后续文件的 totalcounts 列并合并
for file in *ReadsPerGene.out.tab; do
    if [ "$file" != "$first_file" ]; then
        # 获取文件名作为列名，移除扩展名
        file_name=$(basename "$file" ReadsPerGene.out.tab)
        # 提取当前文件的 totalcounts 列并合并
        awk 'NR >3  {print $2}' "$file" | paste -d, "$output_file" - > temp && mv temp "$output_file"

        # 更新表头
        header="${header},${file_name}"
    fi
done

# 在合并后的文件中更新表头
sed -i "1s/.*/$header/" "$output_file"
echo "合并完成，结果保存在 star_total_counts.csv"

