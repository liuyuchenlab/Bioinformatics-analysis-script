#!/bin/bash
mkdir plot;
for mat_file in *_matrix.mat.gz; do
    # 提取前缀（去掉_matrix.mat.gz）：yh2a.x_5S-Deu-L2
    prefix=$(basename "$mat_file" "_matrix.mat.gz")
    # 提取两个下划线之间的内容（实际是按下划线分割取第二个字段）：5S-Deu-L2
    region_label=$(echo "$prefix" | awk -F '_' '{print $2}')
    # 执行核心命令
    plotHeatmap --dpi 600 --sortUsing sum --heatmapWidth 6 --heatmapHeight 15  --colorMap viridis --regionsLabel "$region_label" -m "$mat_file" -out plot/"${prefix}_q20.pdf"
done
