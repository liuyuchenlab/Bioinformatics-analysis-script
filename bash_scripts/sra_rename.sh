#在EBI中搜索Secondary Study Accession:SRP020490（示例）
#选择show column selection，点击添加sample_title和fastq_aspera
#点击左上角的download tsv report
#文件里的第11列为样本名
#保留SRR列和样本名列，删除行名
#!/bin/bash

# 查找当前目录下的第一个 .txt 文件
input_file=$(ls *.txt 2>/dev/null | head -n 1)

# 确保找到输入文件
if [[ -z $input_file ]]; then
  echo "没有找到 .txt 文件!"
  exit 1
fi

echo "使用文件: $input_file"

# 对输入文件中的旧文件名进行排序并重命名
awk -F'\t' '
{
    # 旧文件名（添加 .sra 后缀）
    old_name = $1 ".sra"
    # 新文件名（添加 .sra 后缀）
    new_name = $2 ".sra"
    # 输出旧文件名和新文件名
    print old_name "\t" new_name
}' "$input_file" | sort -k1,1 | while IFS=$'\t' read -r old_name new_name; do
    # 去除可能的换行符
    old_name=$(echo $old_name | tr -d '\r')
    new_name=$(echo $new_name | tr -d '\r')
    
    # 执行重命名
    if [[ -e $old_name ]]; then
        mv $old_name $new_name
        echo "重命名: $old_name -> $new_name"
    else
        echo "文件不存在: $old_name"
    fi
done


#####yeah
