for f in `ls ./../occurrence_allandgazeteer/master_localities/ | sed 's/\..*//g'`; do
echo "species,x,y" > ${f}.csv
cat ./../occurrence_allandgazeteer/master_localities/${f}.csv.unique.noninteger.pointzero.sorted >> ${f}.csv

# If no POWO record, make no change to localities
if [ ! -f ./../powo/${f}.native.shp ]; then
echo "POWO record not found!"
mv ${f}.csv output.csv

# If POWO record found, trim by POWO record
else

# Check to make sure we don't already have output
if [ ! -f ./${f}.powo ]; then
ogr2ogr -f 'ESRI Shapefile' ${f}.shp ${f}.csv -oo X_POSSIBLE_NAMES=x -oo Y_POSSIBLE_NAMES=y -a_srs 'EPSG:4326'
./powo_trim.py ${f}.shp ./../powo/${f}.native.shp output.shp
ogr2ogr -f CSV output.csv output.shp -lco GEOMETRY=AS_XYZ
g=`echo ${f} | sed 's/\..*//g'`
cut -d, -f1,2 output.csv > tmp && mv tmp output.csv
sed -i "s/^/${g},/g" output.csv
rm ${g}.csv ${g}.shp ${g}.shx ${g}.prj ${g}.dbf
echo ${g}.powo

else
echo "Skipping, output exists..."

fi
fi

# In either case above, output.csv is at this point in Maxent format. Move to appropriate filename
mv output.csv ${f}.powo
rm output.*

done