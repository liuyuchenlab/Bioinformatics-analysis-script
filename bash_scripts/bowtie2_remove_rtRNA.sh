## 创建输出目录（存放去rRNA/tRNA后的压缩文件）
mkdir -p remove_rRNA_tRNA

# 循环处理所有双端压缩文件（命名格式：样本名_R1.fq.gz 和 样本名_R2.fq.gz）
for r1_file in *_R1.fq.gz; do
    # 提取样本名（去除_R1.fq.gz后缀，例如将"sample_R1.fq.gz"转为"sample"）
    sample_name=$(basename "$r1_file" _R1.fq.gz)
    # 对应的R2压缩文件
    r2_file="${sample_name}_R2.fq.gz"
    
    # 检查R2文件是否存在（避免因文件缺失报错）
    if [ ! -f "$r2_file" ]; then
        echo "警告：未找到配对文件 $r2_file，跳过样本 $sample_name"
        continue
    fi
    
    # 双端比对并保留未比对的成对reads（输出为未压缩fq，后续手动压缩）
    bowtie2  -x /sc/lyc/index/mouse/bowtie2_rRNA_tRNA/mm39 -1 "$r1_file" -2 "$r2_file"  --un-conc remove_rRNA_tRNA/"${sample_name}_%.fq"  -p 40  -S "${sample_name}_rRNA.sam"  
    
    # 将未压缩的输出文件压缩为.gz（节省空间，与输入格式一致）
    gzip remove_rRNA_tRNA/"${sample_name}_R1.fq"
    gzip remove_rRNA_tRNA/"${sample_name}_R2.fq"
    
    # 删除临时SAM文件（无需保留）
    rm -f "${sample_name}_rRNA.sam"
    
    echo "处理完成：$sample_name → 输出文件："
    echo "  remove_rRNA_tRNA/${sample_name}_R1.fq.gz"
    echo "  remove_rRNA_tRNA/${sample_name}_R2.fq.gz"
done
