#网络数据批量下载
cat SRR_Acc_List.txt | while read id; do kingfisher get -r $id -m aws-http ena-ftp ena-ascp prefetch --output-format sra; done
