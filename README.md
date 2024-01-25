# Biotic_disjunction

## Phylogenomic analyses:
This includes the shell scripts to clean the sequencing data, doing the alignments, getting ASTRAL and RaxML tree
  - [1_process_then_align_subg_virgulus.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/Phylogenomics/1_process_then_align_subg_virgulus.sh): Shell script to do the alignments and get the gene trees for ASTRAL, concatenate alignments and get the concanated tree
  - [exclude_list_ASTRAL.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/Phylogenomics/exclude_list_ASTRAL.sh): This is the list to include all species within subgenus virgulus, outgroups and few species of other subgenera
  - [astral.sushilmegatree.tre](https://github.com/dahalsushil/biotic_disjunction/blob/main/Phylogenomics/Results/astral.sushilmegatree.tre): ASTRAL result
  - [subg.virgulus.raxml.support.tre](https://github.com/dahalsushil/biotic_disjunction/blob/main/Phylogenomics/Results/subg.virgulus.raxml.support.tre): RAxML result

## Biogeographic analyses
### mcmctree
The program uses for inputa sequence alignment (nucleotide or protein), a phylogenetic tree with fossil calibrations, and a control file (usually called mcmctree.ctl) that contains the instructions for the program. MCMCTree is part of the PAML package.
- [astral.sushilmegatree.subg.virgulus.redo.newick.noduplicate.formatted.tre](https://github.com/dahalsushil/biotic_disjunction/blob/main/BioGeoBEARS/mcmctree/astral.sushilmegatree.subg.virgulus.redo.newick.noduplicate.formatted.tre): Dated ASTRAL tree
- [1_mcmctree.BV.ctl](https://github.com/dahalsushil/biotic_disjunction/blob/main/BioGeoBEARS/mcmctree/1_mcmctree.BV.ctl): The control file that contains all the necessary instructions to run the MCMCTree program.
- [mcmc.txt](https://github.com/dahalsushil/biotic_disjunction/blob/main/BioGeoBEARS/mcmctree/mcmc.txt): contains the raw output of the MCMC
- [SeedUsed](https://github.com/dahalsushil/biotic_disjunction/blob/main/BioGeoBEARS/mcmctree/SeedUsed): contains the random seed used to initialize the MCMC
- [FigTree.tre](https://github.com/dahalsushil/biotic_disjunction/blob/main/BioGeoBEARS/mcmctree/FigTree.tre): a version of the posterior tree in nexus format

Try running it in non-executable mode:
```
mcmctree mcmctree.ctl
```
### BioGeoBEARS
- [FigTree.subg.virgulus.tre](https://github.com/dahalsushil/biotic_disjunction/blob/main/BioGeoBEARS/FigTree.subg.virgulus.tre): .tre file
- [biogeobears_subg.virgulus.fixed.tsv](https://github.com/dahalsushil/biotic_disjunction/blob/main/BioGeoBEARS/biogeobears_subg.virgulus.fixed.tsv): .tsv file containing biogeographic range for each species
- [biogeo_symphyo.R](https://github.com/dahalsushil/biotic_disjunction/blob/main/BioGeoBEARS/biogeo_symphyo.R): R script to set up for running BioGeoBEARS
- [symphyo_DEC_vs_DECJ.pdf](https://github.com/dahalsushil/biotic_disjunction/blob/main/BioGeoBEARS/symphyo_DEC_vs_DECJ.pdf): Plot ancestral states - DEC vs DEC+J

## ancestral_niche_reconstruction
First, we will start by building ecological niche models or the species distribution models for the species of interest and then use those models to reconstruct the ancestral niche and predict paleo-ranges as implemented by Folk et al., (2023). 
### niche_modelling
- [0_process_records.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/0_process_records.sh): Shell script to download occurrences records, split files and process file names
- [1_record_cleanup.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/1_record_cleanup.sh): Shell script for basic clean-up, removing outlier, downloading POWO data, and trimming with POWO data
- [2_extract_pointvalues_loop.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/2_extract_pointvalues_loop.sh): This shell script drops only the missing values for each point, so point associations are lost
- [3_csv_to_shapefile_plus_trainingogr_loop.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/3_csv_to_shapefile_plus_trainingogr_loop.sh): Script for writing point shapfiles
- [4_Symphyotrichum_batch_clip.r](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/4_Symphyotrichum_batch_clip.r): R script for batch clippings
- [5_MAXENT_batch.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/5_MAXENT_batch.sh): Script for batch runs of Maxent in a bash shell. This assumes that the species names in the occurrence files are the same as the entry in the species column within the files
- [BatchMask_ryan.r](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/BatchMask_ryan.r): R file for cropping (masking) the raster files with multiple shape file and stores them in separate folders. Masked files are stored in seperate folders with shape file name and names of the masked files are kept same
- [aaa_header.txt](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/aaa_header.txt): Text file that contains the header
- [extract_pointvalues_evenhigherthroughput.py](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/extract_pointvalues_evenhigherthroughput.py): Python script to extract environmental values for points, check for pixelwise duplicates and also to count pixel-wise duplicates
- [powo.py](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/powo.py): Python code needed to download POWO data
- [powo_trim.py](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/powo_trim.py): Script to automate training region development
- [powo_trim_loop.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/powo_trim_loop.sh): Script to trim POWO record
- [remove_geographic_outliers.py](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/remove_geographic_outliers.py): Simple script to remove geographic outliers based on standard deviations of distance. Make sure basic things like exact duplicates have been taken care of so the standard deviations are meaningful.
- [ALL_powo_cleaned_manually.csv](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/ALL_powo_cleaned_manually.csv): .csv that contains the occurrences records that are manually checked
- [training_regions_ogr.py](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/niche_modeling/training_regions_ogr.py): Script to automate training region development. Points should already be ESRI shape files.

Run like this:
```
for f in *.shp; do ./training_regions.py ${f} /Users/Fasch/Desktop/Symphyotrichum_occurrences_test/terr-ecoregions-TNC/tnc_terr_ecoregions.shp; done
```

### pno_calc
- [extract_and_join_climatesuitability.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/ancestral_niche_reconstruction/pno_calc/extract_and_join_climatesuitability.sh): Shell script for a simple Predicted Niche Occupancy (PNO) calculator.

Run Like this
```
bash extract_and_join_climatesuitability.sh path_to_model_folder path_to_environmental_data_folder path_to_extraction_data number_of_bins
```
## Code/Software
- RStudio, Bash

