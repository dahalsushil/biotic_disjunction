#!/usr/bin/env python3

'''
This script calculates species richness from a PAM file.

Run like:

./PAM_to_speciesrichness.py pam_all.specieslist.sorted.pam species_richness.pam

Then: 

./PAM_output_to_asc.py species_richness.pam species_richness.asc 0.5


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
parser.add_argument('input_file', action='store', help='Name of the asc input file.')
parser.add_argument('output_file', action='store', help='Name of the desired output file.')
args = parser.parse_args()

infile = args.input_file # Input asc
outfile = args.output_file # Output 

with open(infile, 'r') as datafile:
	reader=csv.reader(datafile, delimiter='\t')
	with open(outfile, 'w+') as writefile:
		writer = csv.writer(writefile, delimiter='\t')
		for r in reader:
			species_list = r[1].split(",")
			new_row = [r[0], str(len(species_list))]
			writer.writerows([new_row])
			species_list = []



