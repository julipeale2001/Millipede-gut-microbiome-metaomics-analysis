#!/bin/bash -   
#title          :Mapping.sh
#description    :A simple loop to serially map all samples
#author         :Roey Angel and Julius Nweze
#date           :20210429
#version        :Referenced from within https://merenlab.org/tutorials/assembly-based-metagenomics/
#usage          :Run the command
#===========================================================================================================

logFile="03_Mapping.log"

# Change directory to data folder
	cd ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data 

# Activate anvio-7 in the terminal
#	 conda activate anvio-7 
	

# To remove spaces, some special characters in the headers, and any contigs that are shorter than 1,000 bps
	mkdir CONTIGS 
	anvi-script-reformat-fasta ASSEMBLY/final.contigs.fa -o CONTIGS/contigs.fa -l 1000 --simplify-names --report CONTIGS/name_conversions.txt &&


# Produce a .txt containing the sample names
#	ls D*/*_L1_1.fq.gz | cut -d "/" -f2 | cut -d "." -f 1 |cut -d "_" -f 1-3 | uniq > samples.txt &&
    ls D*/*_L1_1.fq.gz | cut -d "/" -f2 | cut -d "." -f 1 |cut -d "_" -f 1-1 | uniq > samples.txt &&

for sample in `awk '{print $1}' samples.txt`
	do
	if [ "$sample" == "sample" ]; then continue; fi

# You need to make sure you "ls D*/*_L1_1.fq.gz" returns R1 files for all your samples in samples.txt
# Co-assemble to produce a single contigs.fa
	R1s=`ls D*/$sample*_L1_1.fq.gz | python -c 'import sys; print(",".join([x.strip() for x in sys.stdin.readlines()]))'`
	R2s=`ls D*/$sample*_L1_2.fq.gz | python -c 'import sys; print(",".join([x.strip() for x in sys.stdin.readlines()]))'` 

# Mapping our reads to the assembly they built
	mkdir MAPPING	
	bowtie2-build CONTIGS/contigs.fa MAPPING/contigs 
	bowtie2 -x MAPPING/contigs -q -1 $R1s -2 $R2s --no-unal -p 4 -S MAPPING/$sample.sam 
	samtools view -F 4 -bS MAPPING/$sample.sam > MAPPING/$sample-RAW.bam 
	anvi-init-bam MAPPING/$sample-RAW.bam -o MAPPING/$sample.bam 
	rm MAPPING/$sample.sam MAPPING/$sample-RAW.bam 
	done &&

# mapping is done, and we no longer need bowtie2-build files
rm MAPPING/*.bt2
