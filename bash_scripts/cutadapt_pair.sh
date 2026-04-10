#
#!/bin/bash

output_dir="snoRNA_trimmed"
qc_raw="qc_raw"
qc_trimmed="qc_trimmed"
mkdir -p $output_dir $qc_raw $qc_trimmed

# 完整双端接头（解决“不完整”警告）W
small_rna_5adapter="GATCGTCGGACT"          # R2的5'接头（正向）
universal_adapter="AGATCGGAAGAG"           # R1的3'接头（正向）
PCR_primer="GTAGACTCTGAACCTGTAATCTCGTGGTCGTGCCCTATCATAAAAA"
anti_PCR="CAATATCATGCAAGTCCCCGGGTCTCGAACTTTTTATGATAGGGCACGACCACGAGATTACAGGTTCAGAGTCTAC"
# 自动计算R2的接头（过滤所有头行，只留纯碱基
adapter_r2_5=$(echo -e "@test\n$small_rna_5adapter\n+\n$(printf "I%.0s" {1..12})" | seqtk seq -a -r | grep -v "^@" | grep -v "^+" | grep -v "^>")
adapter_r2_3=$(echo -e "@test\n$universal_adapter\n+\n$(printf "I%.0s" {1..12})" | seqtk seq -a -r | grep -v "^@" | grep -v "^+" | grep -v "^>")

# 验证接头（无>、无换行）
echo "接头验证："
echo "R1 5'：$small_rna_5adapter"
echo "R1 3'：$universal_adapter"
echo "R2 5'：$adapter_r2_5"
echo "R2 3'：$adapter_r2_3"

# 原始QC
#fastqc *_R1.fq.gz *_R2.fq.gz -t 40 -o $qc_raw

# 双端循环处理（一行式命令）
for r1_file in *_R1.fq.gz; do
    sample_name=$(basename "$r1_file" _R1.fq.gz)
    r2_file="${sample_name}_R2.fq.gz"
    if [ ! -f "$r2_file" ]; then echo "跳过$sample_name"; continue; fi
    out_r1="$output_dir/${sample_name}_R1.fq.gz"
    out_r2="$output_dir/${sample_name}_R2.fq.gz"
    
    # 一行式cutadapt（完整接头，无警告）
    cutadapt -G "$small_rna_5adapter" -a "$universal_adapter" -A "$anti_PCR"  -q 20,20 --nextseq-trim=20 -O 8 --minimum-length 18 --max-n 0.1 -j 40 -o "$out_r1" -p "$out_r2" "$r1_file" "$r2_file"
    
    [ -f "$out_r1" ] && [ -f "$out_r2" ] && echo "✅ $sample_name" || echo "❌ $sample_name"
done

# 质控后QC
fastqc $output_dir/*.fq.gz -t 40 -o $qc_trimmed
echo -e "\n完成！查看QC报告确认接头去除效果"#
