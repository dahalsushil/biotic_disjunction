#!/usr/bin/env python3

'''
This script calculates phylogenetic diversity (as a proportion of the total tree length) from a PAM file.

Run like:

./PAM_to_PD.py pam_all.specieslist.sorted.pam intree.dated.crossvalidated.beast.tre PD.pam absolute
./PAM_to_PD.py pam_all.specieslist.sorted.pam intree.dated.crossvalidated.beast.tre RPD.pam equal

Then:

./PAM_output_to_asc.py PD.pam PD.asc 0.5
./PAM_output_to_asc.py RPD.pam RPD.asc 0.5

'''

import csv
import numpy 
import sys 
import argparse # Parse arguments
import subprocess
import re
import random
import dendropy

parser = argparse.ArgumentParser(description='Script to delete unnecessary fields in locality documets that are tab-delimited and follow DarwinCore header terms.')
parser.add_argument('input_file', action='store', help='Name of the asc input file.')
parser.add_argument('tree_file', action='store', help='Name of the tree file.')
parser.add_argument('output_file', action='store', help='Name of the desired output file.')
parser.add_argument('relative', action='store', help='Option for relative statistic, where the comparison tree has all internal branch lengths 0 and all tips equal to the community tree depth. "equal" for equal branches, "collapse" for internal branches set to zero, anything else for non-relative. To not use relative PD, put "absolute" here.')
args = parser.parse_args()

infile = args.input_file # Input asc
outfile = args.output_file # Output
tree = dendropy.Tree.get(path = args.tree_file, schema = "newick", preserve_underscores=True) # Underscore behavior is important to watch
relative_option = args.relative

tip_list = []
for taxon in list(tree.taxon_namespace):
	tip_list.append(taxon.label)

total_tree_length = tree.length()

# Get equal-branches branch length
node_list = []
for node in tree.postorder_node_iter():
	node_list.append(node)
comparison_tree_branch_length = total_tree_length/len(node_list)
#print(len(node_list))
#print(comparison_tree_branch_length)

# Build comparison tree with equal edges
comparison_tree = dendropy.Tree.get(path = args.tree_file, schema = "newick", preserve_underscores=True) # Reloading the tree so this is an independent object
for edge in comparison_tree.postorder_edge_iter():
    if edge.length is None:
        edge.length = 0
    else:
        edge.length = comparison_tree_branch_length


with open(infile, 'r') as datafile:
	reader=csv.reader(datafile, delimiter='\t')
	with open(outfile, 'w+') as writefile:
		writer = csv.writer(writefile, delimiter='\t')
		for r in reader:
			#print("\nSite is: {}".format(r[0]))
			species_list = r[1].split(",")
			#species_list_matched = [x for x in species_list if species_list in tip_list]
			#print(species_list)
			#print(species_list_matched)

			taxa_to_keep = set(taxon for taxon in tree.taxon_namespace if taxon.label in species_list)
			#print(taxa_to_keep)
			
			# Calculate absolute phylogenetic diversity
			if len(taxa_to_keep) > 1:
				tree0 = tree.extract_tree_with_taxa(taxa_to_keep)
				#print(tree0)
				if tree0.seed_node.edge_length is not None:
					community_tree_length = tree0.length() - tree0.seed_node.edge_length
				else:
					community_tree_length = tree0.length()
				phylodiversity = community_tree_length/total_tree_length

				if relative_option == "absolute":
					denominator = 1
				elif relative_option == "equal":
					taxa_to_keep_comparison = set(taxon for taxon in comparison_tree.taxon_namespace if taxon.label in species_list) # Taxon identifiers will be different for this one so we remake the list
					tree0_comparison = comparison_tree.extract_tree_with_taxa(taxa_to_keep_comparison)
					if tree0_comparison.seed_node.edge_length is not None:
						community_tree_length_comparison = tree0_comparison.length() - tree0_comparison.seed_node.edge_length
					else:
						community_tree_length_comparison = tree0_comparison.length()
					denominator = community_tree_length_comparison/total_tree_length
				else:
					print("Incorrect summary option.")
					sys.exit()
				
				#print("Phylogenetic diversity for site: {}".format(phylodiversity))
				phylodiversity = phylodiversity/denominator
				#print("Phylogenetic diversity for comparison tree: {}".format(denominator)) # Corrected only for relative PD
				#print("Phylogenetic diversity corrected: {}".format(phylodiversity)) # Corrected only for relative PD
				
			else:
				phylodiversity = 0
	
			new_row = [r[0], phylodiversity]
			writer.writerows([new_row])
			species_list = []




