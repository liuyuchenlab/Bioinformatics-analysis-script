ls *.gz |while read id;do  nohup fastqc -t 40 $id -o fastqc;done&
