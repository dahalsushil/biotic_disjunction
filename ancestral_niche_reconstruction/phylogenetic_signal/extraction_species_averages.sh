mkdir environment_final_species_averages

# Make sure the PNO files do not contain spaces or this will break
for variablefile in ./../../../../Botbot/climate_data/Saxifragales_all_layers_30s/*.asc; do
variable=`echo $variablefile | sed 's/\.asc//g' | sed 's/.*\///g'`
#echo $variable
for file in `find ./extractions/ -name "*${variable}_pno*.csv"`; do
#echo $file
species=`echo $file | sed 's/.*_pno_//g' | sed 's/\.csv//g'`
#echo ${species}
average=`cut -d',' -f2 ${file} | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }'`
#echo ${average}
output=`echo -e "${species}\t${average}"`
echo ${output} >> ./environment_final_species_averages/${variable}.average.csv
done
done

