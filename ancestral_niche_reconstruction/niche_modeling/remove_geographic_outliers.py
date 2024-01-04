#!/usr/bin/env python3
# Simple script to remove geographic outliers based on standard deviations of distance. 
# Make sure basic things like exact duplicates have been taken care of so the standard deviations are meaningful.

import csv # To process tab-delimited files
import sys
import argparse # Parse arguments
import os
from geopy.distance import geodesic # Easy distance with realistic spheroid
import numpy

from osgeo.gdalconst import *


parser = argparse.ArgumentParser(description='Script to remove geographic outliers.')
parser.add_argument('input_file', action='store', help='Input file, tab delimited format with no header, species then lat then long.')
args = parser.parse_args()

points_raw = args.input_file

points = []
with open(points_raw, 'r') as datafile:
	reader=csv.reader((line.replace('\0','') for line in datafile),delimiter='\t',quoting=csv.QUOTE_NONE) 
	for r in reader:
		points.append([float(r[2]), float(r[1])]) 
		species = r[0]

#print(points)

latitudes = []
longitudes = []
for point in points:
	latitudes.append(point[0])
	longitudes.append(point[1])

centroid = [numpy.mean(latitudes), numpy.mean(longitudes)]
print("Centroid is: {0}".format(centroid))		

distances = []
for f in points:
	distances.append(geodesic(centroid, f).km)
	print(distances[-1])

bound = numpy.std(distances) * 3 + numpy.mean(distances)
print("Three standard deviation bound is: {0}".format(bound))

cleaned_points = []
for point, distance in zip(points, distances):
	if distance < bound:
		cleaned_points.append(point)
	elif distance == 0:
			cleaned_points.append(point)
		

# print(cleaned_points)

print("Number of outliers removed is {0}, or {1}%.".format(len(points) - len(cleaned_points), (len(points) - len(cleaned_points))/len(points) * 100))

try:
	os.mkdir("./outliers_removed")
except: 
	pass
with open("./outliers_removed/{0}.outliersremoved".format(points_raw), 'w+') as writefile:
	writer = csv.writer(writefile, delimiter=',')
	for point in cleaned_points:
		row = [species, point[0], point[1]]
		writer.writerows([row])
