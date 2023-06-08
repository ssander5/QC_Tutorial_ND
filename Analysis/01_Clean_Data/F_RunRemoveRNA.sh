#!/bin/bash

#$ -M sheri.anne.sanders@gmail.com
#$ -m abe
#$ -q debug
#$ -N RunQC_F

#make output folder

if [ -d bbmap ]; then
    echo "directory exists"
else
    mkdir bbmap
fi

#Get Database
if [ -f ../Reference/smr_v4.3_default_db.fasta ]; then
    echo "rRNA database exists"
else
    wget https://github.com/sortmerna/sortmerna/releases/download/v4.3.3/database.tar.gz
    mv database.tar.gz ../Reference/
    tar -xvf ../Reference/database.tar.gz
fi

echo "Removing rRNA contamination using SortMeRNA database in bbduk"

for f in ./bbmap/*trimclean.sickleclean.spikeclean.hostclean.fq; do
    #bbduk is easier to install, faster to run, and has similar output to sortmerna

    base=${f%trim*}

    bbduk.sh \
    in=${base}trimclean.sickleclean.spikeclean.hostclean.fq \
    ref=../Reference/smr_v4.3_default_db.fasta \
    out=${base}final.clean.fq \
    outm=${base}reads_that_match_rRNA.fq | \
    awk '{print "HOST CONTAMINATION SEQUENCES PAIRED "$0}' | \
    tee -a ./bbmap/$(basename ${base}stats.txt)

done

echo "DONE Removing rRNA contamination using SortMeRNA database in bbduk!"
