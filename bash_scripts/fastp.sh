#!/bin/bash
# fastp单样本顺序处理脚本

input_dir="./"
output_dir="./fastp"
mkdir -p "${output_dir}"

for sample in $(ls "${input_dir}"/*_1.fq.gz | xargs -I {} basename {} "_1.fq.gz"); do
    fastp --thread 40 -i "${input_dir}/${sample}_1.fq.gz" -I "${input_dir}/${sample}_2.fq.gz" -o "${output_dir}/${sample}_1.fq.gz" -O "${output_dir}/${sample}_2.fq.gz" --detect_adapter_for_pe  --length_required 18 --n_base_limit 10 --correction --overlap_diff_limit 1 --overlap_diff_percent_limit 10 --json "${output_dir}/${sample}_fastp.json" --html "${output_dir}/${sample}_fastp.html"
done

multiqc "${output_dir}"/*_fastp.json -o "${output_dir}/"
