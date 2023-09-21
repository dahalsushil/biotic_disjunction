####################
# Basic clean-up
####################

# Make sure we are using unix carriage returns
for f in *.tsv; do
tr -d '\015' <${f} >${f}.unix
done

# Remove duplicates
for f in *.tsv.unix; do
sort -u ${f} > ${f}.unique
done

# Delete non-decimal records
for f in *.tsv.unix.unique; do
sed '/\./!d' ${f} > ${f}.noninteger
done

# Delete non-decimal records
for f in *.tsv.unix.unique.noninteger; do
sed '/.*\.0\t.*\.0$/d' ${f} > ${f}.pointzero
done

# Sort by latitude (unique ruins this so we do it at the end)
for f in *.tsv.unix.unique.noninteger.pointzero; do
sort -k2 -g ${f} > ${f}.sorted
done

# Clean up
for f in *.tsv.unix.unique.noninteger.pointzero.sorted; do
g=`echo $f | sed 's/\.tsv.*//g'`
mv $f $g.cleaned.tsv
done

find . -size 0 -exec rm {} \;

rm *.unix
rm *.unique
rm *.noninteger
rm *.pointzero

####################
# Outlier removal
####################
for f in *.cleaned.tsv; do
python3 ./remove_geographic_outliers.py $f ## download code from github
done

####################
# Download POWO data
####################


ls *.cleaned.tsv | sed 's/\..*//g' | sed 's/×//g' > species_ALL.list.csv

while read p; do
echo $p
./powo.py ${p} ./wgsrpd-master/level3/level3.shp ${p}.native.shp ${p}.introduced.shp
sleep 3
done <species_ALL.list.csv # Species list should INCLUDE underscores not spaces

mkdir powo
mv *.shp *.shx *.dbf ./powo/

####################
# Trim with POWO data
####################

for f in `ls ./outliers_removed/ | sed 's/\..*//g'`; do
echo "species,y,x" > ${f}.csv # add header column
cat ./outliers_removed/${f}.cleaned.tsv.outliersremoved | sed 's/\t/,/g' >> ${f}.csv # add records

# If no POWO record, make no change to localities
if [ ! -f ./powo/${f}.native.shp ]; then
echo "POWO record not found!"
mv ${f}.csv output.csv

# If POWO record found, trim by POWO record
else

# Check to make sure we don't already have output
if [ ! -f ./${f}.powo ]; then
# Change CSV records to SHP format
ogr2ogr -f 'ESRI Shapefile' ${f}.shp ${f}.csv -oo X_POSSIBLE_NAMES=x -oo Y_POSSIBLE_NAMES=y -a_srs 'EPSG:4326'
# Do the trimming
./powo_trim.py ${f}.shp ./powo/${f}.native.shp output.shp
# Convert output back to CSV
ogr2ogr -f CSV output.csv output.shp -lco GEOMETRY=AS_XYZ
# Process the output
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

##########
# Clean up

# POWO range incomplete, use original cleaned data
echo "species,y,x" > Symphyotrichum_purpurascens.powo # add header column
cat ./outliers_removed/Symphyotrichum_purpurascens.cleaned.tsv.outliersremoved | sed 's/\t/,/g' >> Symphyotrichum_purpurascens.powo # add records

# POWO range incomplete, use original cleaned data (looks like the outlier removal still resulted in two points)
echo "species,y,x" > Symphyotrichum_peteroanum.powo # add header column
cat ./outliers_removed/Symphyotrichum_peteroanum.cleaned.tsv.outliersremoved | sed 's/\t/,/g' >> Symphyotrichum_peteroanum.powo # add records

mkdir initial_cleaning
mv *.cleaned.tsv ./initial_cleaning/
mkdir original
mv *.tsv ./original
mkdir powo_cleaned
mv *.powo powo_cleaned



