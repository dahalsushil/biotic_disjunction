# This one drops only the missing values for each point, so point associations are lost
mkdir pnos_directsampling_no_missing_data_no_point_associations
for i in ./../../../../nitfix/Saxifragales_all_layers_30s/*.asc; do
./extract_pointvalues_evenhigherthroughput.py ${i} ./powo_cleaned/
done