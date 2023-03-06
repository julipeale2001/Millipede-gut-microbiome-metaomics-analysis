#!/bin/bash -   
#title          :Profiling.sh
#description    :For sequence annotation 
#author         :Roey Angle and Julius Nweze
#date           :20210429
#version        :
#usage          :Activate anvio-7 before running this script
#==============================================================================================

#Activate anvio-7 before running this script

# Change directory to data folder

	cd ~/proj/Millipedes2/Metagenome/Data/Julius/Data/X201SC21033030-Z02-F001/raw_data

# Profiling our samples

	for i in MAPPING/*.bam
	do	 
	anvi-profile -i $i -c DATABASE/contigs.db -T 20 
	done &&

# The last step is to merge all of these together into one anvi’o “profile”, so that we can consider them all together. This is done as follows:

	anvi-merge MAPPING/*.bam-ANVIO_PROFILE/PROFILE.db -o Merged_profile -c DATABASE/contigs.db &&
# If the number of splits is more than 20,000 read (this https://merenlab.org/2015/05/11/anvi-refine/), use the flag --skip-hierarchical-clustering

#	anvi-merge MAPPING/*.bam-ANVIO_PROFILE/PROFILE.db -o Merged_profile -c DATABASE/contigs.db  --skip-hierarchical-clustering &&

# This is a quick alternative to manually binning your contigs, but it might miss some details that a human doing manual binning would find. After running this, you might want to run anvi-summarize on the resulting collection to look through your bins, and, if necessary, use anvi-refine to change the contents of them.You have to option to use several different clustering algorithms, which you’ll specify with the driver parameter: concoct, metabat2, maxbin2, dastool, and binsanity. https://merenlab.org/software/anvio/help/7/programs/anvi-cluster-contigs/
# So, a run of this program will look like the following:

	anvi-cluster-contigs -p Merged_profile/PROFILE.db -c DATABASE/contigs.db -C Metabat2 --driver metabat2 --just-do-it &&

# First, let’s summarize the bin information for our data. This will produce a series of text-based output files detailing some statistics on our genome bins: 

 	anvi-summarize -p Merged_profile/PROFILE.db -c DATABASE/contigs.db -o Merged_Metabat2_Summary -C Metabat2 &&

# After binning, you can identifing and refining genome bins manually
    anvi-refine -p Merged_profile/PROFILE.db -c DATABASE/contigs.db -C Metabat2 -b METABAT__154 --server-only -P 8081

# Relative abundances of taxa (Contigs db + profile db)
	anvi-estimate-scg-taxonomy -p Merged_profile/PROFILE.db -c DATABASE/contigs.db --metagenome-mode --compute-scg-coverages --output-file SCG-taxonomy.csv &&

# Visualization: use port 8080 if you used it to log into the server. Make sure you have Google Chrome (best for anvio-interactive) 
	anvi-interactive -p Merged_profile/PROFILE.db -c DATABASE/contigs.db  -C Metabat2 --server-only -P 8081

# Remove/eliminating all the bins with low completeness and high redundancy from my collection in anvio:
# Use a combination of anvi-rename-bins, anvi-export-collection, and anvi-import-collection to call MAGs with the first, export all the bin names with the second, create new file with only those that you want to keep, and import that as a new collection with the third program.Then you can get rid of unwanted collections with anvi-delete-collection https://merenlab.org/software/anvio/help/7/programs/anvi-rename-bins/


# When is it OK to say “well, this is the genome bin I will call final, analyze, and publish”?:https://merenlab.org/2016/06/09/assessing-completion-and-contamination-of-MAGs/   https://gitlab.ifremer.fr/rimicaris/rimicaris-exoculata-cephalothoracic-epibionts-metagenomes/-/blob/28d4e3faf373b279c70a0ec5918a559560a81f24/README.md
# > 90% completion + < 10% redundancy ~= Golden
# We usually suggest that in order to report a MAG it should meet both of these minimal criteria:

# More than 50% complete, or more than 2Mb in size1.
# Less than 10% redundant based on Campbell et al.’s BSCGs2.
# A lower completion score may be due to underestimation, but a higher redundancy will almost never be due to overestimation. You must try to clean it up. 
# Just a good reminder that lack of completion does not always mean the genome is not quite well put together, since all BSCGs are originating from isolates, and we know all the biases associated with cultivation.

    anvi-rename-bins -p Merged_profile/PROFILE.db -c DATABASE/contigs.db  --collection-to-read Metabat2 --collection-to-write New_MAGs_Metabat2 --call-MAGs --max-redundancy-for-MAG 10 --min-completion-for-MAG 50  --prefix EG --report-file Concoct.renaming_bins.txt #  --size-for-MAG

# Export the bin information for formatting
	anvi-export-collection -p Merged_profile/PROFILE.db -C New_MAGs_Metabat2 -O New_MAGs_Metabat2
	grep _MAG_ New_MAGs_Metabat2-info.txt > 1FINAL_MAGs_Metabat2-info.txt
	grep _MAG_ Metabat2.renaming_bins.txt > 1FINAL_Metabat2.renaming_bins.txt
	grep -v 'EG_MAG_00005\|EG_MAG_00290\|EG_MAG_00276\|EG_MAG_00309'  1FINAL_MAGs_Metabat2.txt > FINAL_MAGs_Metabat2.txt	
	grep -v 'EG_MAG_00005\|EG_MAG_00290\|EG_MAG_00276\|EG_MAG_00309'  1FINAL_MAGs_Metabat2-info.txt > FINAL_MAGs_Metabat2-info.txt
	grep -v 'EG_MAG_00005\|EG_MAG_00290\|EG_MAG_00276\|EG_MAG_00309'  1FINAL_Metabat2.renaming_bins.txt > FINAL_Metabat2.renaming_bins.txt

# Import the formatted bin information

    anvi-import-collection FINAL_MAGs_Metabat2.txt --bins-info FINAL_MAGs_Metabat2-info.txt -p Merged_profile/PROFILE.db -c DATABASE/contigs.db -C FINAL_MAGs_Metabat2

# Summarise the bins
 	anvi-summarize -p Merged_profile/PROFILE.db -c DATABASE/contigs.db -o Final_SUMMARY_Metabat2 -C FINAL_MAGs_Metabat2

# Delete the unwanted bins
 	anvi-delete-collection -p Merged_profile/PROFILE.db --list-collections (-C collection name)


# anvi-import-misc-data: adding taxa info from GTDB_TK
#	For the layer of taxonomy, create a TAB-delimited file (rows are bins, column(s) are taxon names), and give it to anvi-interactive with '-A' parameter when you're invoking the interface in collection mode.
	anvi-interactive -p Merged_profile/PROFILE.db -c DATABASE/contigs.db -C FINAL_MAGs_Metabat2 -A Metabat2_taxa_info-gtdb-tk.txt --server-only -P 8083

# Import the sample information
	anvi-import-misc-data metadata.txt -p Merged_profile/PROFILE.db --target-data-table layers

# For that I would probably do a different sort of visualization. I.e., all bins represented in one display, first layer would highlight those that were recovered by method one, the second layer would highlight those that were recovered by method second, and so on. The last layer would show taxonomy for each. Sorting those bins based on distribution patterns or phylogenomics show whether there are any patterns regarding which algorithm misses what.

# Ordering of samples: Layer orders additional data table
	anvi-export-misc-data -p Merged_profile/PROFILE.db --target-data-table layers -o layer.txt 


# Depreplicate the MAGs with anvi-dereplicate-genomes: For the identification and removal of redundant MAGs we prepared a genomeinfo.csv file with the MAG IDs and their redundancy and completion estimates.
	anvi-dereplicate-genomes -f Deprep-Metabat2.txt -o Dereplicate-genomes --program pyANI --similarity-threshold 0.90


# GTDB_TK

# Taxonomic assignments of our MAGs was made with GTDB-Tk based on the Genome Database Taxonomy GTDB. The classify workflow consists of three steps: identify, align, and classify.


	mkdir -p PHYLOGENO_GTDB/MAGs_metabat2

	for file in FINAL_SUMMARY_Metabat2/bin_by_bin/*/*-contigs.fa
    do
    file2=$(basename $file | sed 's/-contigs.fa/.fna/g')
    cp $file PHYLOGENO_GTDB/MAGs_Metabat2/$file2
    done

    gtdbtk classify_wf --cpus 80 --genome_dir PHYLOGENO_GTDB/MAGs_metabat2 --out_dir PHYLOGENO_GTDB/classify_wf_output_metabat2


