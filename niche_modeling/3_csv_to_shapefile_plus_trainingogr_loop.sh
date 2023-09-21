# ogr2ogr can't handle arbitrary extensions so change
rename 's/\.powo/.csv/g' ./powo_cleaned/*.powo

# Create vrt files
for i in ./powo_cleaned/*.csv; do 
f=`echo $i | sed 's/\.csv//g' | sed 's/.*\///g'`
echo $f
cp aaa_coord.vrt ./powo_cleaned/${f}.vrt
sed -i "s/output/${f}/g" ./powo_cleaned/${f}.vrt
sed -i "s/coord/${f}/g" ./powo_cleaned/${f}.vrt
sed -i "s/test\.csv/${f}.csv/g" ./powo_cleaned/${f}.vrt
done


# Don't forget vrt template aaa_coord.vrt
'''
<OGRVRTDataSource>
	<OGRVRTLayer name="output">
		<SrcDataSource>test.csv</SrcDataSource>
		<GeometryType>wkbPoint</GeometryType>
		<LayerSRS>WGS84</LayerSRS>
		<GeometryField encoding="PointFromColumns" x="X" y="Y"/>
	</OGRVRTLayer>
</OGRVRTDataSource>
'''

# Write point shapefiles
cd powo_cleaned
for f in *.csv; do 
f=$(sed 's/\.csv//g' <<< $f)
ogr2ogr -f "ESRI Shapefile" ${f}.shp ${f}.vrt
done

# Iterate over csv files for the clipping region calculation
for f in *.shp; do
./../training_regions_ogr.py ${f} ./../terr-ecoregions-TNC/tnc_terr_ecoregions.shp; 
done

