#!/bin/bash
mkdir -p plot

for mat_file in *_matrix.mat.gz; do
    prefix=$(basename "$mat_file" "_matrix.mat.gz")
    plotProfile -m "$mat_file" -out plot/"${prefix}_profile.pdf" --perGroup --regionsLabel "$prefix"
done
