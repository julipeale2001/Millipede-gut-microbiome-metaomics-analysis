#!/bin/bash -   
#title          :Assembly.sh
#description    :A simple loop to serially assemble all samples
#author         :Roey Angel and Julius Nweze
#date           :20220402
#version        :Referenced from within https://github.com/wwood/CoverM#usage
#usage          :Run the command
#===========================================================================================================

# CoverM aims to be a configurable, easy to use and fast DNA read coverage and relative abundance calculator focused on metagenomics applications.

# CoverM calculates coverage of genomes/MAGs coverm genome (help) or individual contigs coverm contig (genes). Calculating coverage by read mapping, its input can either be BAM files sorted by reference, or raw reads and reference genomes in various formats.


# Calculation methods: coverm genome (MAGs) and coverm contig (genes)

# coverm genome - Calculate read coverage per-genome (version 0.6.1): Percentage relative abundance of each genome, and the unmapped read percentage    
    for i in *.fasta          
    do
    coverm genome --coupled ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE2/DE2_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE2/DE2_L1_2.fq.gz ~/   proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE3/DE3_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE3/DE3_L1_2.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE5/DE5_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE5/DE5_L1_2.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE2/RE2_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE2/RE2_L1_2.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE3/RE3_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE3/RE3_L1_2.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE5/RE5_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE5/RE5_L1_2.fq.gz --min-read-percent-identity 95 --reference $i -m tpm --threads 20 -o $i.CoverM.tsv
    done



# coverm contig - Calculate read coverage per-contig (version 0.6.1)
# Gene relative abundances in TPM

# First, backtranseq the protein sequence and write it to nucleic acid sequence
backtranseq -sequence 1.FDHF-Formate-dehydrogenase-H.fasta.faa -outfile fdhF.fasta


    ls FAA/*.hmm.collection.faa | cut -d "/" -f2 | uniq > samples.txt
    for sample in `awk '{print $1}' samples.txt`
	do
	if [ "$sample" == "sample" ]; then continue; fi
    backtranseq -sequence FAA/$sample -outfile $sample.fasta
    done

# Run coverm contig if you have each gene in a fasta file.
    for i in *.fasta          
    do
    coverm contig --coupled ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE2/DE2_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE2/DE2_L1_2.fq.gz ~/   proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE3/DE3_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE3/DE3_L1_2.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE5/DE5_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DE5/DE5_L1_2.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE2/RE2_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE2/RE2_L1_2.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE3/RE3_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE3/RE3_L1_2.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE5/RE5_L1_1.fq.gz ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/DRE5/RE5_L1_2.fq.gz --min-read-percent-identity 95 --reference $i -m tpm --threads 20 -o $i.CoverM.tsv
    done

