# Script for batch runs of Maxent in a bash shell
# Assumes that the species names in the occurrence files are the same as the entry in the species column within the files

# NOTE: need to regularize the clipped grid names
# e.g., folders only named as the species, but clippings inside with species removed
# In clippings directory you can run this: 
cd clippings
rename 's/\.final_shapefile//g' *
for f in `ls -d *`; do cd $f; rename 's/^[^.]*\.//g' *.asc; cd ..; done
for f in `ls -d *`; do cd $f; rename 's/^final_shapefile\.//g' *.asc; cd ..; done
cd ..
# clippings folder should now contain folders named ONLY the species, with .asc files inside named after ONLY the layer

# Maxent options:
# Write fewer grids
# No GUI
# Write simple output to log
# Bootstrap the models in 10 replicates
# 75% of data training, 25% test
# No extrapolation


for f in ./powo_cleaned/*.csv; do
g=`basename $f | sed 's/.csv//g'`
echo ${g}
mkdir ${g}_model
stdbuf -i0 -o0 -e0 java -mx2000m -jar maxent.jar nowarnings noprefixes responsecurves jackknife "outputdirectory=./${g}_model" "projectionlayers=/mnt/Heuheu/nitfix/Saxifragales_all_layers_5min" "samplesfile=./${f}" "environmentallayers=./clippings/${g}" visible=FALSE outputgrids=FALSE writeclampgrid=FALSE randomseed noaskoverwrite randomtestpoints=25 replicates=10 replicatetype=bootstrap noextrapolate maximumiterations=5000 threads=20 allowpartialdata autorun &>> aaa_Symphyotrichum_all.log
done
