#!/usr/bin/env python3

'''
Example:

while read p; do
sleep 3
./powo.py ${p} ./wgsrpd-master/level3/level3.shp ${p}.native.shp ${p}.introduced.shp
done <species_ALL.list.csv



'''



import pykew.powo as powo
from pykew.powo_terms import Filters, Name
import argparse
from osgeo import ogr
import os
 
def get_kew_id_for_species(species_name):
	results = powo.search(species_name, filters=[Filters.accepted, Filters.species])
	if results.size() > 0:
		return [res['fqId'] for res in results][0]
	return None

def get_species_kew(fq_id):
	result = powo.lookup(fq_id, include=['distribution'])
	return result

parser = argparse.ArgumentParser(description='Script to get TDWG region descriptors given an input species name.')
parser.add_argument('species', action='store', help='Genus_species string.')
parser.add_argument('level3', action='store', help='TDWG level3 shapefile.')
parser.add_argument('output_native', action='store', help='Output file for native range.')
parser.add_argument('output_introduced', action='store', help='Output file for native range.')
args = parser.parse_args()

species = args.species
output_native = args.output_native
output_introduced = args.output_introduced
species = species.replace("_", " ")

#level1 = shapefile.Reader(args.level1).shapeRecords()[0]
level3 = ogr.Open(args.level3)
layer = level3.GetLayer()
layer.SetAttributeFilter("FIELD = 'tdwgCode'")

print(species)

# List of fields in the shapefile in case you need to look these up
field_names = [field.name for field in layer.schema]
print(field_names)

# Fetch POWO internal ID
id = get_kew_id_for_species(species)
print(id)

# Query POWO by internal ID
output = get_species_kew(id)

range = []

# Define output file for native
out_driver = ogr.GetDriverByName( 'ESRI Shapefile' )
if os.path.exists(output_native):
    out_driver.DeleteDataSource(output_native)
out_ds = out_driver.CreateDataSource(output_native)
out_layer = out_ds.CreateLayer(output_native, geom_type= ogr.wkbPolygon)

# Do the range lookup
for f in output['distribution']['natives']: # Subset to distribution native
	code = f['tdwgCode'] # Get area code
	print(code)
	temp = layer # Make a layer copy
	temp.SetAttributeFilter ( "LEVEL3_COD = '{}'".format(code) ) # Subset the layer by level three code
	# write to disk
	for feature in temp:
		out_feat = ogr.Feature(out_layer.GetLayerDefn())
		out_feat.SetGeometry(feature.GetGeometryRef().Clone())
		out_layer.CreateFeature(out_feat)
		out_feat = None
		out_layer.SyncToDisk()
		

# Define output file for native
out_driver = ogr.GetDriverByName( 'ESRI Shapefile' )
if os.path.exists(output_introduced):
    out_driver.DeleteDataSource(output_introduced)
out_ds = out_driver.CreateDataSource(output_introduced)
out_layer = out_ds.CreateLayer(output_introduced, geom_type= ogr.wkbPolygon)

# Do the range lookup
try:
	for f in output['distribution']['introduced']: # Subset to distribution native
		code = f['tdwgCode'] # Get area code
		print(code)
		temp = layer # Make a layer copy
		temp.SetAttributeFilter ( "LEVEL3_COD = '{}'".format(code) ) # Subset the layer by level three code
		# write to disk
		for feature in temp:
			out_feat = ogr.Feature(out_layer.GetLayerDefn())
			out_feat.SetGeometry(feature.GetGeometryRef().Clone())
			out_layer.CreateFeature(out_feat)
			out_feat = None
			out_layer.SyncToDisk()
except:
	print("No introduced range; empty shapefile written.")		





