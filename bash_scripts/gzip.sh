ls *fastq |while read id;do ( gzip $id &);done
