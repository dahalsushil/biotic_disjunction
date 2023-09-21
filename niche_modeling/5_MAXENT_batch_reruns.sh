for f in ./powo_cleaned_redos/*.csv; do
g=`basename $f | sed 's/.csv//g'`
echo ${g}
mkdir ${g}_model
stdbuf -i0 -o0 -e0 java -mx2000m -jar maxent.jar nowarnings noprefixes responsecurves jackknife "outputdirectory=./${g}_model" "projectionlayers=/mnt/Heuheu/nitfix/Saxifragales_all_layers_5min" "samplesfile=./${f}" "environmentallayers=./clippings_redos/${g}" visible=FALSE outputgrids=FALSE writeclampgrid=FALSE randomseed noaskoverwrite randomtestpoints=25 replicates=10 replicatetype=bootstrap noextrapolate maximumiterations=5000 threads=20 allowpartialdata autorun &>> aaa_Symphyotrichum_all_reruns.log
done
