#网络数据批量下载
cat SRR_Acc_List.txt | parallel -j 3 "kingfisher get -r {} -m aws-http prefetch --output-format sra"
