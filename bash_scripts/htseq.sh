#
#!/bin/bash
gtf_file="/sc/lyc/index/mouse/ref/genecode/gencode.vM38.chr_patch_hapl_scaff.annotation.gtf"
output_dir="htseq_counts"
mkdir -p $output_dir
for bam_file in *.sorted.bam; do
    sample_name=$(basename "$bam_file" .sorted.bam)
    count_file="$output_dir/${sample_name}.txt"
    echo "正在处理样本：$sample_name"
    htseq-count -f bam -r pos -s no -a 10 -i gene_name --nprocesses 40 "$bam_file" "$gtf_file" > "$count_file"
    echo "✅ 样本$sample_name处理完成，结果：$count_file"
done
echo -e "\n🎉 所有样本定量完成！结果在$output_dir"#
