#!/usr/bin/env python3

'''
This script calculates phylogenetic endemism from a PAM file.

Run like:

./PAM_to_PE.py pam_all.specieslist.sorted.pam pam_all.pam intree.dated.crossvalidated.beast.tre PE.pam absolute
./PAM_to_PE.py pam_all.specieslist.sorted.pam pam_all.pam intree.dated.crossvalidated.beast.tre RPE.pam equal

Then:

./PAM_output_to_asc.py PE.pam PE.asc 0.5
./PAM_output_to_asc.py RPE.pam RPE.asc 0.5


'''

import csv
import numpy 
import sys 
import argparse # Parse arguments
import subprocess
import re
import os
import random
import dendropy

import random # To avoid temp file overlap

parser = argparse.ArgumentParser(description='Script to delete unnecessary fields in locality documets that are tab-delimited and follow DarwinCore header terms.')
parser.add_argument('input_file', action='store', help='Name of the asc input file.')
parser.add_argument('all_pam_file', action='store', help='Name of the all_pam file. This is a list of each site for each species.')
parser.add_argument('tree_file', action='store', help='Name of the tree file.')
parser.add_argument('output_file', action='store', help='Name of the desired output file.')
parser.add_argument('relative', action='store', help='Option for relative statistic, where the comparison tree has all internal branch lengths 0 and all tips equal to the community tree depth. "equal" for equal branches. To not use relative PE, put "absolute" here.')
args = parser.parse_args()

infile = args.input_file # Input asc
outfile = args.output_file # Output
allpamfile = args.all_pam_file
tree = dendropy.Tree.get(path = args.tree_file, schema = "newick", preserve_underscores=True) # Underscore behavior is important to watch
relative_option = args.relative
 
r = random.randint(1,10000000000)

tip_list = []
for taxon in list(tree.taxon_namespace):
	tip_list.append(taxon.label)
	
#print(tip_list)

# Get total tree length
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


print("Sorting all PAM file.")
os.system("sort -k2 {} > temp_PE.{}".format(allpamfile,r))

print("Loading all PAM file into memory.")
all_site_database = {}
# Load all sites into memory, much faster
with open("temp_PE.{}".format(r), 'r') as allpamfile:
	reader=csv.reader(allpamfile, delimiter='\t')
	last_row = next(reader)
	sites = []
	for r in reader:
		sites.append(last_row[0])	# Get the site
		if r[1] == last_row [1]: # If we are still in the same species, move on
			pass 
		else: # If we have moved to a new species, write the site list and species
			current_species = last_row[1]
			all_site_database.update({current_species: sites})
			sites = []
		last_row = r

def childrecursive(taxonlist,node): # A recursive approach is necessary to iterate through children of children until we have arrived at all tips
	for child in node.child_node_iter():
		if child.is_leaf():
			taxonlist.append(child.taxon.label)
		elif child.is_internal():
			childrecursive(taxonlist,child) # Cannot use node from before, will get infinite recursion; must use child node


def GetCladeRangeSize(node):
	site_list = []
	taxon_list = node[0]
	for taxon in taxon_list:
		l = all_site_database.get(taxon)
		try: # In case range size is zero; we correct for this below.
			for x in l:
				site_list.append(x)
		except:
			pass
	site_list = list(set(site_list))
	clade_range_size = len(site_list)
	
	if clade_range_size == 0:
		clade_range_size = 1
		print("Had to correct range size 0 to 1 for taxa:")
		print(taxon_list)
		
	#print(taxon_list)
	#print("Cumulative clade range for clade: {}".format(clade_range_size))
	return clade_range_size


def TraverseTree(tree0):
	nodelist = []
	taxonlist = []
	for node in tree0.preorder_node_iter():
		if node is not tree0.seed_node: # Skip root node
			if node.is_leaf():
				taxonlist.append(node.taxon.label)
			else:
				childrecursive(taxonlist,node)
			nodelist.append([taxonlist, node.edge_length])
		else:
			print("Skipping root node.")
		taxonlist = []
	
	returnlist = []
	for node in nodelist:
		if node is not tree0.seed_node: # Skip root node
			clade_range_size = GetCladeRangeSize(node)
			try:
				phyloendemism_branch = (node[1]/total_tree_length)/clade_range_size # Divide clade cumulative range size by length of branch subtending node. Branch length is normalized by total tree length.
				returnlist.append(phyloendemism_branch)
			except:
				print("Could not calculate phyloendemism for node; likely just skipping a root node.")
		else: 
			print("Skipping root node.")
	phyloendemism_total = sum(returnlist)
	
	return phyloendemism_total

print("Calculating phylogenetic endemism.") 

with open(infile, 'r') as datafile:
	reader=csv.reader(datafile, delimiter='\t')
	with open(outfile, 'w+') as writefile:
		writer = csv.writer(writefile, delimiter='\t')
		for r in reader:
			print("\nSite is: {}".format(r[0]))
			species_list = r[1].split(",")
			taxa_to_keep = set(taxon for taxon in tree.taxon_namespace if taxon.label in species_list)
			#print(taxa_to_keep)
			
			if len(taxa_to_keep) > 1:
				tree0 = tree.extract_tree_with_taxa(taxa_to_keep)
				print(tree0)
				phyloendemism = TraverseTree(tree0)
			
				if relative_option == "equal":
					taxa_to_keep_comparison = set(taxon for taxon in comparison_tree.taxon_namespace if taxon.label in species_list) # Have to rerun this since taxon IDs could be different
					tree0_comparison = comparison_tree.extract_tree_with_taxa(taxa_to_keep_comparison)
					print(tree0_comparison)
					denominator = TraverseTree(tree0_comparison)			
				elif relative_option == "absolute":
					denominator = 1
				else:
					print("Invalid summary option.")
					sys.exit()
			
			else:
				phyloendemism = 0
				denominator = 1

			print("Phylogenetic endemism for site: {}".format(phyloendemism)) # Corrected only for relative PE
			print("Phylogenetic endemism for comparison tree: {}".format(denominator)) # Corrected only for relative PE
			
			phyloendemism = phyloendemism/denominator # Denominator is the summed PE for the comparison tree.
			
			print("Corrected phylogenetic endemism for site: {}".format(phyloendemism)) # Corrected only for relative PE

			
			new_row = [r[0], phyloendemism]
			writer.writerows([new_row])
			species_list = []

os.system("rm temp_PE.{}".format(r))

