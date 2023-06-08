#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_B

echo "Running FastQC and Generating Stats"

#make output folder
if [ -d "fastqc" ]; then
    echo "./fastqc exists"
else
    mkdir fastqc
fi

for g in ../../Input_data/*fastq; do
      fastqc -o ./fastqc $g
done


echo "BBMAP stats"
if [ -d "bbmap" ]; then
    echo "./bbmap exists"
else
    mkdir bbmap
fi

for g in ../../Input_data/*fastq; do
    o=${g#../../Input_data/}
    reformat.sh threads=16 in=$g > ./bbmap/${o%_1*}.stats.txt
done

echo "DONE Running FastQC and Generating Stats!"
