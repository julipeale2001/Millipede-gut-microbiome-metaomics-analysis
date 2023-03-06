#!/bin/bash -   
#title          :Profiling.sh
#description    :For sequence annotation 
#author         :Roey Angel and Julius Nweze
#date           :20210429
#version        :
#usage          :Activate anvio-7 before running this script
#==============================================================================================



# Activate anvio-7 before running this script

# Change directory to data folder
	cd ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data

# Read https://merenlab.org/2017/06/07/phylogenomics/

# Selecting genes from an HMM Profile
#	  anvi-get-sequences-for-hmm-hits -c DATABASE/contigs.db -p Merged_profile/PROFILE.db -o  Metabat2-seqs-for-phylogenomics.fa --list-hmm-sources

#  Let’s see what genes do we have in Bacteria_71
# 	anvi-get-sequences-for-hmm-hits -c DATABASE/contigs.db -p Merged_profile/PROFILE.db -o Metabat2-seqs-for-phylogenomics.fa --hmm-source Bacteria_71 --list-available-gene-names

# The following command will give us all these genes from all bins described in the collection. You can select any combination of these genes to use for your phylogenomic analysis, including all of them –if you do not declare a --gene-names parameter, the program would use all. But considering the fact that ribosomal proteins are often used for phylogenomic analyses, we decided to use all the 39 ribosomal proteins:
	anvi-get-sequences-for-hmm-hits -c DATABASE/contigs.db -p Merged_profile/PROFILE.db -o Metabat2-seqs-for-phylogenomics.fa --hmm-source Bacteria_71 --gene-names Ribosomal_L1,Ribosomal_L2,Ribosomal_L3,Ribosomal_L4,Ribosomal_L5,Ribosomal_L6,Ribosomal_S7,Ribosomal_L9_C,Ribosomal_L13,Ribosomal_L14,Ribosomal_L16,Ribosomal_L17,Ribosomal_L18p,Ribosomal_L19,Ribosomal_L20,Ribosomal_L21p,Ribosomal_L22,Ribosomal_L23,ribosomal_L24,Ribosomal_L27,Ribosomal_L27A,Ribosomal_L28,Ribosomal_L29,Ribosomal_L32p,Ribosomal_L35p,Ribosomal_S2,Ribosomal_S20p,Ribosomal_S3_C,Ribosomal_S6,Ribosomal_S8,Ribosomal_S9,Ribosomal_S10,Ribosomal_S11,Ribosom_S12_S23,Ribosomal_S13,Ribosomal_S15,Ribosomal_S16,Ribosomal_S17,Ribosomal_S19 -C FINAL_MAGs_Metabat2 --return-best-hit --get-aa-sequence  --concatenate-genes# Look at the resulting FASTA file (press q to exit)

#	less Metabat2-seqs-for-phylogenomics.fa

# Computing the phylogenomic tree
#	anvi-gen-phylogenomic-tree -f Metabat2-seqs-for-phylogenomics.fa -o Metabat2-phylogenomic-tree.txt

# visualize it immediately with anvi-interactive
	 anvi-interactive -t Metabat2-phylogenomic-tree.txt -p temp-profile.db --title "Pylogenomics of Epibolus and Glomeris Hindgut MAGs" --manual --server-only -P 8083

# Include taxa
	anvi-interactive -t Metabat2-phylogenomic-tree.txt -p tempC-profile.db -d Metabat2_taxa_info-gtdb-tk.txt --title "Phylogenomics of Epibolus and Glomeris Hindgut MAGs (binned with Metabat2)" --manual --server-only -P 8083


# We can do much more with this phylogenomic tree of our bins than visualizing it in manual mode
	anvi-interactive -p Merged_profile/PROFILE.db -c DATABASE/contigs.db -C FINAL_MAGs_Metabat2 -A Metabat2_taxa_info-gtdb-tk.txt -t Metabat2-phylogenomic-tree.txt --title "Metagenomics and Phylogenomics of Epibolus and Glomeris Hindgut MAGs (binned with Metabat2)" --server-only -P 8084

