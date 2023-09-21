#!/usr/bin/env python3

'''
This script does global PAM randomizations.

Run like:

cut -f2 pam_all.specieslist.sorted.pam | tr '\n' ',' | tr -d '\r' > random_species_pool.txt # This creates the species pool for randomization with quick bash tools; last step is to handle Mac carriage returns that appeared on my system
# Have pre-calculated species richness for this step
./PAM_to_randomized_PAM.py species_richness.pam random_species_pool.txt 1000 pam_random 
mkdir randomizations
mv pam_random_*.pam randomizations


'''

import csv
import numpy 
import sys 
import argparse # Parse arguments
import subprocess
import re
import random

parser = argparse.ArgumentParser(description='Script to perform randomization without replacement, keeping species richness constant.')
parser.add_argument('input_file', action='store', help='Name of the asc input file.')
parser.add_argument('species_pool', action='store', help='Name of the asc input file.')
parser.add_argument('replicate_number', action='store', help='Name of the asc input file.')
parser.add_argument('output_file', action='store', help='Name of the desired output file.')
args = parser.parse_args()

infile = args.input_file # Input asc
species_pool = args.species_pool # Input asc
replicate_total = int(args.replicate_number)
outfile = args.output_file # Output 

species_list = []
with open(species_pool, 'r') as datafile:
	reader=csv.reader(datafile, delimiter=',')
	species_list = next(reader)
	
species_list = list(filter(None, species_list)) # Remove empty strings
print("Number of community records:")
print(len(species_list))


for i in range(0, replicate_total):
	sampled_species_list = numpy.random.choice(species_list, len(species_list))
	with open(infile, 'r') as datafile:
		reader=csv.reader(datafile, delimiter='\t')
		with open("".join([outfile, "_", str(i), ".pam"]), 'w+') as writefile:
			writer = csv.writer(writefile, delimiter='\t')
			for r in reader:
				species_number = int(r[1])
				new_community = sampled_species_list[0:species_number] 
				sampled_species_list =  sampled_species_list[species_number:]
				new_row = [r[0], ",".join(new_community)]
				writer.writerows([new_row])
