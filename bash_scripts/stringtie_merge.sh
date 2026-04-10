find  . -name *.gtf >  merglist.txt
stringtie --merge -p 8 -G /disk5/lyc/reference/mouse/mm10/mm10-2020-A_build/gencode.vM23.primary_assembly.annotation.gtf.filtered.gtf  -o stringtie/stringtie_merge.gtf merglist.txt
gffcompare  -R -r /disk5/lyc/reference/mouse/mm10/mm10-2020-A_build/gencode.vM23.primary_assembly.annotation.gtf.filtered.gtf stringtie_merged.gtf -o compare

