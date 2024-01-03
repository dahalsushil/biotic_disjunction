# Biotic_disjunction

## Phylogenomics:
This includes the shell scripts to clean the sequencing data, doing the alignments, getting ASTRAL and RaxML tree
  - [1_process_then_align_subg_virgulus.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/Phylogenomics/1_process_then_align_subg_virgulus.sh): Shell script to do the alignments and get the gene trees for ASTRAL, concatenate alignments and get the concanated tree
  - [exclude_list_ASTRAL.sh](https://github.com/dahalsushil/biotic_disjunction/blob/main/Phylogenomics/exclude_list_ASTRAL.sh): This is the list to include all species within subgenus virgulus, outgroups and few species of other subgenera
  - [astral.sushilmegatree.tre](https://github.com/dahalsushil/biotic_disjunction/blob/main/Phylogenomics/Results/astral.sushilmegatree.tre): ASTRAL result
  - [subg.virgulus.raxml.support.tre](https://github.com/dahalsushil/biotic_disjunction/blob/main/Phylogenomics/Results/subg.virgulus.raxml.support.tre): RAxML result

## BioGeoBEARS
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
- [biogeo_symphyo.R](https://github.com/dahalsushil/biotic_disjunction/blob/main/BioGeoBEARS/biogeo_symphyo.R): R script to set up for running BioGeoBEARS

## Code/Software
- RStudio, Bash

