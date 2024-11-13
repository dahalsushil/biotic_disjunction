mkdir environment_final_species_soiltype_mode

# Make sure the PNO files do not contain spaces or this will break
for variablefile in ./../../../../Botbot/climate_data/Saxifragales_all_layers_30s/soiltype*.asc; do
variable=`echo $variablefile | sed 's/\.asc//g' | sed 's/.*\///g'`
#echo $variable
for file in `find ./extractions/ -name *${variable}_pno*.csv`; do
#echo $file
species=`echo $file | sed 's/.*_pno_//g' | sed 's/\.csv//g'`
#echo ${species}
mode=`cut -d',' -f2 ${file} | sort | uniq -c | sort -n -r | sed '/variable/d' | head -1 | sed 's/.* //g'`
#echo ${mode}
output=`echo -e "${species}\t${mode}"`
echo ${output} >> ./environment_final_species_soiltype_mode/${variable}.mode.csv
done
done
