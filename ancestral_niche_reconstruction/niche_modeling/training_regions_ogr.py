#!/usr/bin/env python3
# Script to automate training region development

# Points should already be ESRI shape files
# Run like:
'''
for f in *.shp; do ./training_regions.py ${f} /Users/Fasch/Desktop/Heuchera_occurrences_test/terr-ecoregions-TNC/tnc_terr_ecoregions.shp; done
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


parser = argparse.ArgumentParser(description='Script to automatically develop shape files for training regions.')
parser.add_argument('input_file', action='store', help='Name of the desired input file.') 
parser.add_argument('input_ecoregions', action='store', help='Name of the desired ecoregion shapefile.') # MUST BE ABSOLUTE PATH
args = parser.parse_args()

print("Current file is {0}.".format(args.input_file))
    
points_fixed = [pt for pt in fiona.open(args.input_file)] # Import points (already as an ESRI shapefile)

# Temporary data structure for making a MultiPoint object
points_other = []
for i,pt in enumerate(points_fixed):
	point = shape(pt['geometry'])
	points_other.append(point)
	
print("Calculating convex hull.")
multipoint_object = shapely.geometry.multipoint.MultiPoint(points_other) # Make multipoint object
convexhull = multipoint_object.convex_hull

print("Calculating buffered convex hull.")
bufferedhull = convexhull.buffer(0.5) # Buffer hull at 0.5 degrees

# Spatial indexing of ecoregion layer.
# This step is critical; naively iterating through ecoregions increases calculation time by orders of magnitude.
print("Indexing ecoregions.")
ecoregions_fixed = [pol for pol in fiona.open(args.input_ecoregions)]
from rtree import index
idx = index.Index()
for pos, poly in enumerate(ecoregions_fixed):
	idx.insert(pos, shape(poly['geometry']).bounds)

print("Done indexing ecoregions.")

print("Harvesting ecoregions.")
   
eco_shapes = []    
for i,pt in enumerate(points_fixed): # Iterate over points
	point = shape(pt['geometry'])
	for j in idx.intersection(point.coords[0]): # Iterate through spatial index of ecoregions if there is a chance for a match.
		if point.within(shape(ecoregions_fixed[j]['geometry'])): # If the point is in the ecoregion...
			eco_shapes.append(shape(ecoregions_fixed[j]['geometry'])) # ...we take the ecoregion.
    
eco_shapes_reduced = []
for eco_shape in eco_shapes: # Take only unique items (dictionary method); otherwise have duplicates
    if eco_shape not in eco_shapes_reduced:
        eco_shapes_reduced.append(eco_shape)

print("Number of unique ecoregions contained: {0}".format(len(eco_shapes_reduced))) 

print("Calculating the intersection.")
final_shape = [] 
for poly in eco_shapes_reduced:
	final_shape.append(poly.intersection(bufferedhull)) # May need pip install --no-use-wheel shapely

# Define schema, etc.
with fiona.open(args.input_ecoregions) as source:
    source_driver = source.driver
    source_crs = source.crs
    source_schema = { 'geometry': 'Polygon', 'properties': { 'name': 'str' } }

# Print types (there should be no GeometryCollections -- would indicate lack of intersection which should not happen
# Number of items should be number of unique ecoregions contained
for f in final_shape:
	print(type(f))

# The syntax of writing in a schema is very fiddly -- careful with the following:
with fiona.open('{0}.final_shapefile.shp'.format(args.input_file), 'w', driver = source_driver, crs = source_crs, schema = source_schema) as output: # Save result in case it is relevant
	for c in final_shape:
		output.write({
			'properties': {
					'name': 'str' 
				},
			'geometry': geometry.mapping(c)
			})
		#output.write({'properties': source_schema['properties'],'geometry': geometry.mapping(shape(final_shape))})

print("Done.")
