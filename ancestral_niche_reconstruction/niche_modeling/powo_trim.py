#!/usr/bin/env python3
# Script to automate training region development

# Points should already be ESRI shape files
# Run like:
'''
for f in *.sorted; do 
echo "species,x,y" > ${f}.csv
cat ${f} >> ${f}.csv
ogr2ogr -f 'ESRI Shapefile' ${f}.shp ${f}.csv -oo X_POSSIBLE_NAMES=x -oo Y_POSSIBLE_NAMES=y -a_srs 'EPSG:4326'
./powo_trim.py ${f}.shp Trifolium_repens.native.shp output.shp
ogr2ogr -f CSV ${f}.powo output.shp -lco GEOMETRY=AS_XYZ
g=`echo ${f} | sed 's/\..*//g'`
cut -d, -f1,2 output.csv > tmp && mv tmp output.csv
sed "s/^/${g},/g" output.csv > tmp && mv tmp output.csv
rm *.sorted.*
echo ${g}.powo
mv output.csv ${g}.powo
rm output.*
done
'''

import os
import sys
import csv # To process tab-delimited files
import argparse # Parse arguments
from osgeo import ogr
import fiona # Simplifies shape file input output
from shapely.geometry import shape
from shapely import geometry
import shapely
from rtree import index
import pandas


parser = argparse.ArgumentParser(description='Script to automatically develop shape files for training regions.')
parser.add_argument('input_file', action='store', help='Name of the desired input file.') 
parser.add_argument('input_powo', action='store', help='Name of the desired powo shapefile.') # MUST BE ABSOLUTE PATH
parser.add_argument('output_file', action='store', help='Name of the desired output file.') 
args = parser.parse_args()

print("Current file is {0}.".format(args.input_file))
    
points_fixed = [pt for pt in fiona.open(args.input_file)] # Import points (already as an ESRI shapefile)
	
# Spatial indexing of powo layer.
# This step is critical; naively iterating through polygons increases calculation time by orders of magnitude.
print("Indexing range.")
powo = [pol for pol in fiona.open(args.input_powo)]
from rtree import index
idx = index.Index()
for pos, poly in enumerate(powo):
	idx.insert(pos, shape(poly['geometry']).bounds)

print("Finding points in range.")
   
kept_points = []    
for i,pt in enumerate(points_fixed): # Iterate over points
	point = shape(pt['geometry'])
	for j in idx.intersection(point.coords[0]): # Iterate through spatial index of powo if there is a chance for a match.
		if point.within(shape(powo[j]['geometry'])): # If the point is in the powo...
			kept_points.append(point) # ...we take the point.
    
print("Percent of points kept: {0}".format(len(kept_points)/len(points_fixed)*100)) 

# Define schema, etc.
with fiona.open(args.input_file) as source:
    source_driver = source.driver
    source_crs = source.crs
    source_schema = { 'geometry': 'Point', 'properties': { 'name': 'str' } }

# The syntax of writing in a schema is very fiddly -- careful with the following:
with fiona.open(args.output_file, 'w', driver = source_driver, crs = source_crs, schema = source_schema) as output: # Save result in case it is relevant
	for point in kept_points:
		output.write({
			'properties': {
					'name': 'str' 
				},
			'geometry': geometry.mapping(point)
			})
		#output.write({'properties': source_schema['properties'],'geometry': geometry.mapping(shape(final_shape))})

print("Done.")
