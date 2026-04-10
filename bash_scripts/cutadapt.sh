
#!/bin/bash

# 定义输出文件夹路径
output_dir="cutadapt"

# 确保输出文件夹存在
mkdir -p $output_dir

# 循环处理当前目录中的每个输入文件
for input_file in *.fq.gz; do
    # 提取文件名（不包含路径）
    file_name=$(basename $input_file)
    # 定义输出文件路径
    output_file="$output_dir/$file_name"
    
    # 运行cutadapt命令
    cutadapt -g TCCGATCT -g CACGTCTC -O 8 -n 5 -e 0 --action=trim -o $output_file $input_file
    
    # 输出处理完成的信息
    echo "Trimming $input_file completed. Output saved to $output_file"
done
