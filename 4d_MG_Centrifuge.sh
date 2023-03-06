#!/bin/bash -   
#title          :Centrifuge.sh
#description    :For sequence annotation 
#author         :Roey Angel and Julius Nweze
#date           :20210429
#version        :
#usage          :Activate anvio-7 before running this script
#==============================================================================================

# Change directory to data folder
	cd ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data

# Use the centrifuge inside the Sequence.Annotation folder # If the environment variable $CENTRIFUGE_BASE is not properly set, you will get an error
#	git clone https://github.com/infphilo/centrifuge
#	cd centrifuge
#	make
#	sudo make install prefix=/usr/local

# Building indexes
#	cd indices
#	make p+h+v                   # bacterial, human, and viral genomes [~12G]
#	make p_compressed            # bacterial genomes compressed at the species level [~4.2G] # Recommended
#	make p_compressed+h+v        # combination of the two above [~8G]

# Run the centrifuge from its folder /home/nweze/proj/Sequence.Annotations
	~/proj/Metagenomic_sequence_classification_tools/Centrifuge/centrifuge-1.0.3-beta/centrifuge -f -x ~/proj/Metagenomic_sequence_classification_tools/Centrifuge/centrifuge-1.0.3-beta/p_compressed+h+v Gene_call/gene_calls.fa -S centrifuge_hits.tsv && 
	
# It is time to import these results! 
	anvi-import-taxonomy-for-genes -c DATABASE/contigs.db -i centrifuge_report.tsv centrifuge_hits.tsv -p centrifuge &&

	mv centrifuge_report.tsv centrifuge_hits.tsv Gene_call


