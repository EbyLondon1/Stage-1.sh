# Stage-1.sh
wget https://raw.githubusercontent.com/HackBio-Internship/wale-home-tasks/main/DNA.fa
grep -c "^>" DNA.fa | wc -c
grep -v "^>" DNA.fa | wc -c
conda install -c bioconda fastqc
conda install -c bioconda/label/cf201901 fastp
conda install -c bioconda seqtk
mkdir dataset
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Alsen_R1.fastq.gz?raw=true -O Alsen_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Baxter_R2.fastq.gz?raw=true -O Baxter_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Chara_R1.fastq.gz?raw=true -O Chara_R1.fastq.gz
mkdir output
fastqc raw_reads/*.fastq.gz -o Output
bash trim.sh
conda install -c bioconda bbmap
repair.sh in1=trimmed_reads/Alsen_R1.fastq.gz in2=trimmed_reads/Alsen_R2.fastq.gz out1=Alsen_R1_rep.fastq.gz out2=Alsen_R2_rep.fastq.gz outsingle=single.fq
repair.sh in1=trimmed_reads/Baxter_R1.fastq.gz in2=trimmed_reads/Baxter_R2.fastq.gz out1=Baxter_R1_rep.fastq.gz out2=Baxter_R2_rep.fastq.gz outsingle=single.fq
repair.sh in1=trimmed_reads/Chara_R1.fastq.gz in2=trimmed_reads/Chara_R2.fastq.gz out1=Chara_R1_rep.fastq.gz out2=Chara_R2_rep.fastq.gz outsingle=single.fq
bwa index references/reference.fasta
bwa mem references/reference.fasta Alsen_R1_rep.fastq.gz  Alsen_R2_rep.fastq.gz > alignment/Alsen.sam
bash aligner.sh
samtools view sample_Alsen.sorted.bam | head -n 5
multiqc Output
