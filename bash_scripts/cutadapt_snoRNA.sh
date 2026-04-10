#
#
#!/bin/bash

# 1. 定义输出和QC目录
output_dir="snoRNA_trimmed"
qc_dir="snoRNA_qc"
trim_qc="trimed_qc"
mkdir -p $output_dir $qc_dir $trim_qc

# 2. 目标接头序列（必核对！替换为你的实际接头）
universal_adapter="AGATCGGAAGAG"  # 第一个：Illumina Universal Adapter（3'端）
small_rna_5adapter="GATCGTCGGACT"          # 第三个：Illumina Small RNA 5'Adapter（5'端）

# 3. 预处理：先运行FastQC查看原始污染情况
fastqc *.fq.gz -t 20 -o $qc_dir
echo "原始QC报告已保存到：$qc_dir"

# 4. 循环处理所有测序文件（去接头+PolyG+质量过滤）
for input_file in *.fq.gz; do
    file_name=$(basename $input_file)
    output_file="$output_dir/$file_name"
    
    # 核心命令：去除指定接头+PolyG
    cutadapt -g $small_rna_5adapter  -a $universal_adapter  --nextseq-trim=20 -q 20,20 -O 8  --minimum-length 18 -j 20 --max-n 0.1 -o $output_file $input_file
    
    echo "✅ 处理完成：$input_file -> $output_file"
done

# 5. 后处理：验证质控效果（再次运行FastQC对比）
fastqc $output_dir/*.fq.gz -t 20 -o $trim_qc
echo -e "\n🎉 所有步骤完成！"
echo "📁 质控后文件路径：$output_dir"
