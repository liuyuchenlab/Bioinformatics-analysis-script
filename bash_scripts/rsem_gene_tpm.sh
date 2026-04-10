#!/bin/sh

# 创建一个 CSV 文件并添加表头
output_file="rsem_gene_tpm.csv"
header="gene_id"

# 提取第一个文件的 gene_id 和 TPM 列
first_file=$(ls *.genes.results | head -n 1)
awk 'NR > 1 {print $1 "," $6}' "$first_file" > "$output_file"

# 获取第一个文件的列名（作为列名）
first_file_name=$(basename "$first_file" .genes.results)
header="$header,$first_file_name"

# 提取后续文件的 TPM 列并合并
for file in *.genes.results; do
    if [ "$file" != "$first_file" ]; then
        # 获取文件名作为列名
        file_name=$(basename "$file" .genes.results)

        # 提取当前文件的 TPM 列，删除多余的 gene_id
        awk -v file_name="$file_name" 'NR > 1 {print $6}' "$file" > temp_file.txt

        # 合并 gene_id 列和 TPM 列
        paste -d, "$output_file" temp_file.txt > temp_merged.txt

        # 将合并后的内容保存回输出文件
        mv temp_merged.txt "$output_file"

        # 更新表头
        header="${header},${file_name}"
    fi
done

# 在合并后的文件中更新表头
sed -i "1s/.*/$header/" "$output_file"
echo "合并完成，结果保存在 rsem_gene_tpm.csv"

