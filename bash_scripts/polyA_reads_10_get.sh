# 创建存储polyA reads的文件夹
mkdir -p polyA_reads
# 提取尾部包含10个以上A或U碱基的序列
# 循环遍历所有BAM文件
for bam_file in *Aligned.sortedByCoord.out.bam; do
    # 1. 提取BAM文件头信息并保存
    samtools view -@ 40 -H "$bam_file" > polyA_reads/"${bam_file%Aligned.sortedByCoord.out.bam}_header.sam"

    # 2. 筛选出包含polyA尾部（最后50个碱基中连续10个A或U）
    samtools view -@ 40 "$bam_file" | awk '{if (match(substr($10, length($10)-49), /A{10,}/) || match(substr($10, length($10)-49), /T{10,}/)) print $0}' > polyA_reads/"${bam_file%Aligned.sortedByCoord.out.bam}_polyA_reads.sam"

    # 3. 合并头信息和过滤后的reads
    cat polyA_reads/"${bam_file%Aligned.sortedByCoord.out.bam}_header.sam" polyA_reads/"${bam_file%Aligned.sortedByCoord.out.bam}_polyA_reads.sam" > polyA_reads/"${bam_file%Aligned.sortedByCoord.out.bam}_polyA_reads_with_header.sam"

    # 4. 将SAM文件转换为FASTA格式
    samtools fasta -@ 40 polyA_reads/"${bam_file%Aligned.sortedByCoord.out.bam}_polyA_reads_with_header.sam" > polyA_reads/"${bam_file%Aligned.sortedByCoord.out.bam}_polyA_sequences.fasta"
done

