#
#
#!/bin/bash

# 1. 定义路径和参数（修改为你的实际路径）
cutadapt_dir="snoRNA_trimmed"  # Cutadapt处理后的目录（含R1/R2）
sickle_dir="sickle_clean"
sickle_log_dir="$sickle_dir/logs"
qc_dir="sickle_qc"

# 质量参数
qual_threshold=20
min_length=18
threads=12

# 2. 创建目录
mkdir -p $sickle_dir $sickle_log_dir $qc_dir

# 3. 运行Sickle（双端数据用sickle pe）
echo "⚡ 开始处理双端数据..."
for r1_file in $cutadapt_dir/*_R1.fq.gz; do
    # 匹配对应的R2文件（假设命名格式为*_R1.fq.gz和*_R2.fq.gz）
    r2_file=${r1_file/_R1/_R2}
    # 提取样本名（去除_R1.fq.gz）
    sample_name=$(basename $r1_file | sed 's/_R1.fq.gz//')
    
    # 定义输出文件和日志
    sickle_r1="$sickle_dir/${sample_name}_R1.fq.gz"
    sickle_r2="$sickle_dir/${sample_name}_R2.fq.gz"
    sickle_log="$sickle_log_dir/${sample_name}_trim.log"
    
    # Sickle双端命令
    sickle pe  -f $r1_file  -r $r2_file  -o $sickle_r1         -p $sickle_r2   -q $qual_threshold -l $min_length -g  2> $sickle_log  
    
    echo "处理完成：$sample_name → R1/R2输出至$sickle_dir（日志：$sickle_log）"
done

# 4. 验证QC
echo -e "\n🔍 生成双端数据QC报告..."
fastqc $sickle_dir/*.fq.gz -t $threads -o $qc_dir

# 5. 汇总
echo -e "\n🎉 完成！"
echo "📁 双端clean数据：$sickle_dir"
echo "📊 QC报告：$qc_dir"
echo "📝 日志：$sickle_log_dir"
