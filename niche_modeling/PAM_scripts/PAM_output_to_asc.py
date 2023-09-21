#!/usr/bin/env python3

'''
This script converts the sorted, postprocessed output of combine_PAM.py into a global asc for visualization.

The final field of the PAM file (the site-specific data) should be converted into something meaningful like species richness.

Run this for half-degree resolution:
./PAM_output_to_asc.py species_richness.pam species_richness.asc 0.5


Then run:
gdal_translate -of GTiff species_richness.asc species_richness.tif 


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
import numpy

parser = argparse.ArgumentParser(description='Script to delete unnecessary fields in locality documets that are tab-delimited and follow DarwinCore header terms.')
parser.add_argument('input_file', action='store', help='Name of the asc input file.')
parser.add_argument('output_file', action='store', help='Name of the desired output file.')
parser.add_argument('pixel_size', action='store', help='Dimensions of one pixel; usually 0.008333333333.')
args = parser.parse_args()

infile = args.input_file # Input asc
outfile = args.output_file # Output 
pixel_size = float(args.pixel_size)

xlim = int(round(360/pixel_size))
ylim = int(round(180/pixel_size))

print("X limit is: {}".format(str(xlim)))
print("Y limit is: {}".format(str(ylim)))

coordinate_list = []
data_list = []

with open(infile, 'r') as datafile:
	reader = csv.reader(datafile, delimiter='\t')
	for row in reader:
		row_list = row[0].split("_")
		row_list = [int(i) for i in row_list] # Important for indexing below
		#print(type(row_list[0]))
		#print(row_list)
		coordinate_list.append(row_list)
		data_list.append(float(row[1]))
	
print("Number of records in PAM:")
print(len(coordinate_list))
#print(coordinate_list)
	
array = numpy.array(coordinate_list) # Convert read-in coordinate list to array
data_array = numpy.array(data_list) # We need to represent the data in a separate array from the coordinates since mixed data types are not supported but coordinates must be float
data_array = data_array.reshape(-1, 1) # Convert one row of data to one column of data to support slicing below
matrix = numpy.full((ylim, xlim), -9999, dtype=float) # Initialize ASC matrix based on column and row number above, -9999 as missing data
matrix[array[:,1], array[:,0]] = data_array[:,0] # Populate ASC matrix with the data column, noting that numpy is y,x but PAM format is x,y hence the inversion

# Print summary stats to help diagnose problems
print("Sample of ASC matrix:")
print(matrix)
print("Maximum data value:")
print(numpy.max(matrix))
print("Minimum data value:")
print(numpy.min(matrix[matrix != -9999]))
print("Mean data value:")
print(numpy.mean(matrix[matrix != -9999]))
	
with open(outfile, 'w+') as writefile:
	writer = csv.writer(writefile, delimiter=' ', quoting = csv.QUOTE_NONE)
	writer.writerows([["ncols",None,None,None,None,None,None,None,None,"{}".format(xlim)]])
	writer.writerows([["nrows",None,None,None,None,None,None,None,None,"{}".format(ylim)]])
	writer.writerows([["xllcorner",None,None,None,None,"-180.000000000000"]])
	writer.writerows([["yllcorner",None,None,None,None,"-90.000000000000"]])
	writer.writerows([["cellsize",None,None,None,None,None,"{}".format(pixel_size)]])
	writer.writerows([["NODATA_value",None,"-9999"]])
	for row in matrix:
		writer.writerows([row])
		writefile.flush() # To prevent buffering
writefile.close()

