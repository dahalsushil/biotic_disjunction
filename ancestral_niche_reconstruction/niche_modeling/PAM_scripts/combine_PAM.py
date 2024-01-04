#!/usr/bin/env python3

'''
This script takes list of pixel coordinates for presences, and converts it into a list of sites and species lists.
This uses output of asc_to_PAM.py. Rather than building matrices, we very quickly do row comparisons, avoiding putting too much in RAM.
Make sure the input has been properly sorted as indicated in asc_to_PAM.py -- the first column must be in order.

The output is a list of sites and species lists.

Run like:

./combine_PAM.py pam_all.pam pam_all.specieslist.pam

When done run this sorting script:

sed 's/_/\t/' pam_all.specieslist.pam > pam_all.specieslist.sorted.pam # Do NOT use g (global) -- want to convert first field separator from _ to \t
sort -k2n,2 -k1n,1  pam_all.specieslist.sorted.pam > temp && mv temp pam_all.specieslist.sorted.pam # Sort numerically by second field (Y) and then first field (X) -- since we write line by line we want them organized by row then column
sed 's/\t/_/' pam_all.specieslist.sorted.pam > temp && mv temp pam_all.specieslist.sorted.pam # back to underscore for site_ids

'''

import csv
import numpy 
import sys 
import argparse # Parse arguments
import subprocess
import re
import random
import scipy.spatial
import itertools

parser = argparse.ArgumentParser(description='Script to delete unnecessary fields in locality documets that are tab-delimited and follow DarwinCore header terms.')
parser.add_argument('input_file', action='store', help='Name of the input file.')
parser.add_argument('output_file', action='store', help='Name of the desired output file.')
args = parser.parse_args()

infile = args.input_file # Input asc
outfile = args.output_file # Output 

species_list = []

with open(infile, 'r') as datafile:
	reader=csv.reader(datafile, delimiter='\t')
	last_row = next(reader)
	with open(outfile, 'w+') as writefile:
		writer = csv.writer(writefile, delimiter='\t')
		for r in reader:
			species_list.append(last_row[1])	# Get the species
			if r[0] == last_row [0]: # If we are still in the same site, move on
				pass 
			else: # If we have moved to a new site, write the species list and site
				current_row = last_row[0]
				print(species_list)
				writer.writerows([[current_row, ",".join(species_list)]])
				species_list = []
			last_row = r

#print(site_list)

