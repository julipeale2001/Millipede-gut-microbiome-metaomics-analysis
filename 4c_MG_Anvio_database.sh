#!/bin/bash -   
#title          :Anvio_database.sh
#description    :Generate an anvi’o contigs database from our co-assembly fasta file (contigs.fa)
#author         :Roey Angel and Julius Nweze
#date           :20210429
#version        :
#usage          :Activate anvio-7 before running this script
#==============================================================================================


# Change directory to data folder
	cd ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data 
	
# Anvi’o Time!

# Building up our contigs database
	mkdir DATABASE
	anvi-gen-contigs-database -f CONTIGS/contigs.fa -o DATABASE/contigs.db -n "my metagenome" && # Generate an anvi’o contigs database from our co-assembly fasta file

# Using the program HMMER to scan for a commonly used set of bacterial single-copy genes
	anvi-run-hmms -c DATABASE/contigs.db -T 20 &&
#	anvi-run-hmms -I Bacteria_71 -c DATABASE/contigs.db  --num-threads 28 && # You can use -I Bacteria_71, Archaea_76, Protista_83, or Ribosomal_RNAs instead
#	anvi-run-hmms -I Archaea_76 -c DATABASE/contigs.db  --num-threads 28 &&
#	anvi-run-hmms -I Protista_83 -c DATABASE/contigs.db  --num-threads 28 &&
	

# Use NCBI COGs for functional annotation of the open-reading frames prodigal predicted
	anvi-setup-ncbi-cogs -T 4 --just-do-it &&
	anvi-run-ncbi-cogs -c DATABASE/contigs.db  -T 4 &&

# Populating contigs db with SCG taxonomy https://merenlab.org/2019/10/08/anvio-scg-taxonomy/
	anvi-setup-scg-taxonomy &&
	anvi-run-scg-taxonomy -c DATABASE/contigs.db &&

# Estimating taxonomy https://merenlab.org/2019/10/08/anvio-scg-taxonomy/
    anvi-estimate-scg-taxonomy -c DATABASE/contigs.db --metagenome-mode &&

# Start the anvi'o interactive interactive for viewing or comparing contigs statistics.
	anvi-display-contigs-stats DATABASE/contigs.db &&

# Get the stats as a supplementary table
	anvi-display-contigs-stats DATABASE/contigs.db --report-as-text -o contigs-stats.csv && # OR use this --report-as-text --as-markdown -o OUTPUT_FILE_NAME.md


# Assign taxonomy with a tool called Centrifuge to the open-reading frames prodigal predicted 
	mkdir Gene_call &&
	anvi-get-sequences-for-gene-calls -c DATABASE/contigs.db -o Gene_call/gene_calls.fa 




