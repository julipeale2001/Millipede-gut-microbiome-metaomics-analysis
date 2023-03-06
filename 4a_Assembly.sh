#!/bin/bash -   
#title          :Assembly.sh
#description    :A simple loop to serially assemble all samples
#author         :Roey Angel and Julius Nweze
#date           :20210429
#version        :Referenced from within http://merenlab.org/tutorials/assembly_and_mapping
#usage          :Run the command
#===========================================================================================================

logFile="02_Assembly.log"

# Change directory to data folder
	cd ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data/ &&

# Activate anvio-7 in the terminal
#	 conda activate anvio-7 
# Use the following to activate anvio-7 before running in zsh or run it bash by typing bash in the command line 


# Co-assemble to produce a single contigs.fa
	R1s=`ls D*/*_L1_1.fq.gz | python -c 'import sys; print(",".join([x.strip() for x in sys.stdin.readlines()]))'`
	R2s=`ls D*/*_L1_2.fq.gz | python -c 'import sys; print(",".join([x.strip() for x in sys.stdin.readlines()]))'`
	echo $R1s
	echo $R2s

# We are ready to run MEGAHIT
	megahit -1 $R1s -2 $R2s -o ASSEMBLY -t 20 
	
