# 获取所有以 "*.cntTable" 结尾的文件列表
file_list=$(ls *.cntTable)

# 获取第一个文件名，用于提取基因名
first_file=$(echo "$file_list" | head -n 1)
column_name=$(echo "$first_file" | sed 's/.cntTable//')

# 提取基因名列
cut -f 1 "$first_file" > gene_names.txt

# 逐个添加文件的第二列数据
for file in $file_list; do
    col_name=$(echo "$file" | sed 's/.cntTable//')
    cut -f 2 "$file" > "${col_name}.expr"
done

# 合并数据并添加列名
paste gene_names.txt *.expr > merged_result.txt

# 添加列名行
header_line="gene_id"
for file in $file_list; do
    col_name=$(echo "$file" | sed 's/.cntTable//')
    header_line="${header_line}\t${col_name}"
done
sed -i "1s/.*/$header_line/" merged_result.txt

# 删除临时文件
rm -f gene_names.txt *.expr

