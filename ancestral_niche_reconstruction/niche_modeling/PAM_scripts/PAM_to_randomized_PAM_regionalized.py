#!/usr/bin/env python3

'''
This script does PAM randomizations, while accounting for regionalizations using the 16 WWF regions. This should already be a PAM file by this point.

Run like:


cp pam_all.specieslist.sorted.pam pam_all.specieslist.sorted.REGIONALIZED.pam # Make a copy to add a new column

while IFS= read -r line; do
a=`echo "$line" | sed 's/\t.*//g'`; 
b=`echo "$line" | sed 's/.*\t//g'`; 
echo $a
sed -i "s/^${a}\t/${a}\t${b}\t/g" pam_all.specieslist.sorted.REGIONALIZED.pam;
done < 16WWFbiomes.pam 


cp species_richness.pam species_richness.REGIONALIZED.pam # Make a copy to add a new column

while IFS= read -r line; do
a=`echo "$line" | sed 's/\t.*//g'`; 
b=`echo "$line" | sed 's/.*\t//g'`; 
echo $a
sed -i "s/^${a}\t/${a}\t${b}\t/g" species_richness.REGIONALIZED.pam;
done < 16WWFbiomes.pam 


# !!!! Check these two regionalized files by eye for odd carriage returns -- character encoding can cause problems !!!!

# If value is zero, that means a coast-line error... correct like so by copying value of nearest neighbor:

last=11 # Start with arctic biome
rm pam_all.specieslist.sorted.REGIONALIZED.fixed.pam
while IFS= read -r line; do
current=`echo $line | cut -f2 -d ' '`
site=`echo $line | cut -f1 -d ' '`
richness=`echo $line | cut -f3 -d ' '`
echo $current
if [ "$current" == "0" ]; then
echo yikes
echo "$site\t$last\t$richness" | sed 's/\\t/\t/g' >> pam_all.specieslist.sorted.REGIONALIZED.fixed.pam
else
echo $line | sed 's/ /\t/g' >> pam_all.specieslist.sorted.REGIONALIZED.fixed.pam
last="${current}"
fi
done < pam_all.specieslist.sorted.REGIONALIZED.pam


last=11 # Start with arctic biome
rm species_richness.REGIONALIZED.fixed.pam
while IFS= read -r line; do
current=`echo $line | cut -f2 -d ' '`
site=`echo $line | cut -f1 -d ' '`
richness=`echo $line | cut -f3 -d ' '`
echo $current
if [ "$current" == "0" ]; then
echo yikes
echo "$site\t$last\t$richness" | sed 's/\\t/\t/g' >> species_richness.REGIONALIZED.fixed.pam
else
echo $line | sed 's/ /\t/g' >> species_richness.REGIONALIZED.fixed.pam
last="${current}"
fi
done < species_richness.REGIONALIZED.pam



rm random_species_pool.REGIONALIZED.txt
for z in `cut -f2 pam_all.specieslist.sorted.REGIONALIZED.fixed.pam | sort | uniq`; do
echo $z
grep -P "\t${z}\t" pam_all.specieslist.sorted.REGIONALIZED.fixed.pam | cut -f3 | tr '\n' ',' | tr -d '\r' | sed "s/^/${z}\t/g" >> random_species_pool.REGIONALIZED.txt # This creates the species pool for randomization with quick bash tools; last step is to handle Mac carriage returns that appeared on my system
sed -i 's/,$/\n/g' random_species_pool.REGIONALIZED.txt
done

~/Desktop/Random\ scripts/Saxifragales_scripts/occurrence_scripts/PAM_postprocessing/PAM_to_randomized_PAM_regionalized.py species_richness.REGIONALIZED.fixed.pam random_species_pool.REGIONALIZED.txt 1000 pam_random
mkdir randomizations_regionalized
mv pam_random_*.pam randomizations_regionalized


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

csv.field_size_limit(sys.maxsize) # Needed for large CSVs

infile = args.input_file # Input asc
species_pool = args.species_pool # Input asc
replicate_total = int(args.replicate_number)
outfile = args.output_file # Output 

species_list = {}
with open(species_pool, 'r') as datafile:
	reader=csv.reader(datafile, delimiter='\t')
	for r in reader:
		biome = str(r[0])
		species = r[1].split(",")
		species_list[biome] = species
	
species_list = {k: v for k, v in species_list.items() if v is not None} # Remove empty strings
#print(species_list)


for i in range(0, replicate_total):
	print("On replicate: {}".format(i))
	sampled_species_list = {} 
	for biome in species_list:
		sampled_species_list[biome] = numpy.random.choice(species_list[biome], len(species_list[biome])) # Randomize species list within each biome
	with open(infile, 'r') as datafile:
		reader=csv.reader(datafile, delimiter='\t')
		with open("".join([outfile, "_", str(i), ".pam"]), 'w+') as writefile:
			writer = csv.writer(writefile, delimiter='\t')
			for r in reader:
				species_number = int(r[2])
				biome = str(r[1])
				new_community = sampled_species_list[biome][0:species_number] 
				species_list[biome] =  sampled_species_list[biome][species_number:]
				new_row = [r[0], ",".join(new_community)]
				writer.writerows([new_row])
