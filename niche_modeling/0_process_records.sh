cd /Users/sushildahal/Desktop/MSU\ graduate\ school/Projects/Floristic\ Disjunction/Ecological\ niche\ modelling

########
# GBIF
########

cd gbif\ dataset/

head -1 occurrence.csv | tr -s '\t' '\n' | nl -nln |  grep "acceptedScientificName" | cut -f1 # Use column 241 which this look-up returns

# Count species; field 241 is accepted species
cut -f241 occurrence.csv | sed 's/ /_/' | sed 's/ .*//g' | sort | uniq | wc -l

# Split into files
mkdir split_files
for f in `cut -f241 occurrence.csv | sed 's/ /_/' | sed 's/ .*//g' | sort | uniq`; do
g=`echo $f | sed 's/_/ /g'`
echo $g
cut -f241,139,138 occurrence.csv | grep -P "\t${g} " > ./split_files/${f}.tsv
done

# at this point manually handle synonyms
mkdir trash
mv Brachyactis\ gymnocephala.tsv trash
mv Brachyactis_gymnocephala.tsv trash
mv Aster.tsv  trash
mv Symphyotrichum_Nees.tsv trash
mv acceptedScientificName.tsv trash
mv Brachyactis_hybrida.tsv trash

mkdir temp
mv Aster_ericoides.tsv "Aster ericoides.tsv" Symphyotrichum_ericoides.tsv temp
cat ./temp/Aster_ericoides.tsv ./temp/"Aster ericoides.tsv" ./temp/Symphyotrichum_ericoides.tsv > Symphyotrichum_ericoides.tsv


mv Aster_puniceus.tsv Aster\ puniceus.tsv Symphyotrichum_puniceum.tsv temp
cat ./temp/Aster_puniceus.tsv ./temp/Aster\ puniceus.tsv ./temp/Symphyotrichum_puniceum.tsv > Symphyotrichum_puniceum.tsv

mv Aster\ subulatus.tsv Aster_subulatus.tsv Symphyotrichum_subulatum.tsv Symphyotrichum_subulatus.tsv Tripolium_subulatum.tsv temp
cat ./temp/Aster\ subulatus.tsv ./temp/Aster_subulatus.tsv ./temp/Symphyotrichum_subulatum.tsv ./temp/Symphyotrichum_subulatus.tsv ./temp/Tripolium_subulatum.tsv > Symphyotrichum_subulatum.tsv

# Process file names
for f in *.tsv; do
g=`echo $f | sed 's/\..*//g'`
sed "s/^/${g}\t/g" $f > $f.processed
awk '{ print $1, $3, $2 }' $f.processed > tmp && mv tmp $f.processed
sed -i 's/ /\t/g' $f.processed
sed -i '1s/^/species\tx\ty\n/' $f.processed
done

# finish up
mv *.tsv temp
rename 's/\.processed//g' *.processed

########
# iDigBio
########
cd ..; cd idigbio\ data/

echo "#!/usr/bin/env python" > csv2tsv.py
echo "import csv, sys" >> csv2tsv.py
echo "csv.writer(sys.stdout, dialect='excel-tab').writerows(csv.reader(sys.stdin))" >> csv2tsv.py

# Convert to tab-delimited -- too difficult to use CSV
cat occurrence.csv | python3 csv2tsv.py > occurrence.tsv

head -1 occurrence.tsv | tr -s '\t' '\n' | nl -nln |  grep "dwc:scientificName" | cut -f1 # Use column 70 which this look-up returns for species name
head -1 occurrence.tsv | tr -s '\t' '\n' | nl -nln |  grep "idigbio:geoPoint" | cut -f1 # Use column 37 which this look-up returns for point


# Count species; field 241 is accepted species
cut -f70 occurrence.tsv | sed 's/ /_/' | sed 's/ .*//g' | sort | uniq | wc -l

# Split into files
mkdir split_files
for f in `cut -f70 occurrence.tsv | sed 's/ /_/' | sed 's/ .*//g' | sort | uniq`; do
g=`echo $f | sed 's/_/ /g'`
echo $g
cut -f70,37 occurrence.tsv | grep -P "\t${g} " > ./split_files/${f}.tsv
done

# At this point, we found no species-determined iDigBio records
