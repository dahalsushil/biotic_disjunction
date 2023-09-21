# Convert to 2-line fasta
for f in *.FNA; do
seqtk seq -l0 $f > $f.fa
done


# Remove individual sequences in favor of their redos
for f in `cat * | grep ">" | sort | uniq | grep "redo"`; do
g=`echo $f | sed 's/_redo//g'`
sed -i "/>${g}$/,+1d" *.fa 
done

sed -i 's/_redo//g' *.fa


# Remove individual sequences in favor of their redos
for f in `cat * | grep ">" | sort | uniq | grep "redo"`; do
g=`echo $f | sed 's/_redo//g'`
sed -i "/>${g}$/,+1d" *.fa 
done
sed -i 's/_redo//g' *.fa

for f in `cat * | grep ">" | sort | uniq | grep "nov2020"`; do
g=`echo $f | sed 's/_nov2020//g'`
sed -i "/>${g}$/,+1d" *.fa 
done
sed -i 's/_nov2020//g' *.fa


# Subset to study taxa
# Sushil official list September 2023
for file in *.fa; do
echo $file
grep -P -A 1 ">.*_E468$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1085$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1086$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E132$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E417$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E418$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E471$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E472$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E481$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E478$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E133$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E477$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E475$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E476$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1078$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E474$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2544$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E480$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E482$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E426$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E427$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E428$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E429$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E430$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E473$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1087$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1087$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1068$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E470$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E431$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E432$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E469$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E479$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E433$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E56$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1982$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1985$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2559$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2564$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2557$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E139$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E140$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1989$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1990$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1997$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1089$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2013$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2014$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1092$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1093$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1094$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2565$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2566$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2634$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1116$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1117$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1120$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E339$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1134$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1138$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1157$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1071$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2027$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2029$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1173$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2571$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2572$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2579$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1072$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2585$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2586$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2588$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2589$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2591$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1073$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E130$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2034$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2037$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2047$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2058$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2074$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2075$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2637$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2638$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2652$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2653$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2654$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2111$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2112$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2114$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2141$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2149$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2158$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E103$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2598$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2599$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2183$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2184$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2185$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1057$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2187$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2188$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1075$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1000$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1007$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1008$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E956$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E962$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E964$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2602$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2605$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2606$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2610$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2613$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1076$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2543$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2640$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2641$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2642$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E77$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E79$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E81$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E108$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2192$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2196$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2643$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E970$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E972$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E973$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E109$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E974$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2201$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2202$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E166$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2226$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2228$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2231$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2241$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2249$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2252$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1081$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2266$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2267$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2269$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2646$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E886$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E887$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E907$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E186$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E84$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E88$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E113$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E805$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E909$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E114$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2289$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2296$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E120$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E188$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E189$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1069$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E197$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E914$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2635$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E210$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E212$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2311$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2325$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2326$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2331$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E198$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E199$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E201$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E930$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E931$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E936$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2352$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2355$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2356$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E215$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2362$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2363$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2370$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2387$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2389$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2548$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2549$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2392$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2403$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2407$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E835$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E836$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E837$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2417$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2418$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2423$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2430$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2431$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2433$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2655$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2648$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2649$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E865$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E882$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E883$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E123$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2439$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2450$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2452$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2461$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2462$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2463$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E810$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E1082$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2625$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2626$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2627$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2470$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2473$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2474$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E763$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E772$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E776$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E228$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E229$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2479$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E231$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2628$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2629$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2486$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2488$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2491$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E798$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E801$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E804$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E223$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E224$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E226$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2516$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2517$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2518$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E785$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E792$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E793$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E227$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2536$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2538$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2631$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2632$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2633$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E467$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2618$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2620$" $file >> $file.wholegenus.fasta
grep -P -A 1 ">.*_E2623$" $file >> $file.wholegenus.fasta
done


# Count total samples
grep --no-filename ">" *.wholegenus.fasta | sort | uniq | wc -l

# Detect duplicates (loci > 353) and bad samples (loci << 353) by enumerating loci per sample
for g in `grep --no-filename ">" *.wholegenus.fasta | sort | uniq`; do 
echo $g; 
grep -P "${g}\$" *.wholegenus.fasta | wc -l;  
done

# Remove some badly sequenced taxa 
sed -i "/>.*_E785$/,+1d" *.wholegenus.fasta
sed -i "/>.*_E792$/,+1d" *.wholegenus.fasta 
sed -i "/>.*_E1078$/,+1d" *.wholegenus.fasta
sed -i "/>.*_E1086$/,+1d" *.wholegenus.fasta

# Remove any duplicates, taking the last occurrence (redo last assuming folders sort correctly, using tac and taking the first), noting $1 is column 1 for comparing names and not sequences
for f in *.wholegenus.fasta; do
cat $f | tr '\n' '\t' | sed 's/\t>/\n>/g' | tac | awk '! seen[$1]++' | tac | sed 's/\t/\n/g' | sed '/^--$/d' > ${f}.unique.fasta
done

# Detect duplicates (loci > 277) and bad samples (loci << 277) by enumerating loci per sample, counting unique files and generating a count file this time
for f in `grep --no-filename ">" *.unique.fasta | sort | uniq`; do 
echo $f >> AAA_counts.txt; 
grep -P "$f$" *.unique.fasta | wc -l >> AAA_counts.txt; 
done

# Do the alignments

for f in *.unique.fasta; do 
mafft --thread -4 --op 3 --ep 0.123 --auto $f > ${f}.aligned.fa; # Run mafft, allowing it to decide best parameters
# The higher gap cost is important in regions with long strings of Ns
# I tried replacing auto with L-INS-i, but runtimes were unacceptable
# Make sure the taxon order is unchanged in mafft output -- this is important for concatenating correctly when there is more than one sample per species present.
done


# Remove high missing data SITES

for f in *.aligned.fa; do 
pxclsq -s $f -p 0.5 > $f.50missing.fa
done


# Remove high missing data TAXA

for f in *.50missing.fa; do 
python3 removemissingdatataxa.py $f $f.80taxadropped.fa 0.2
done



# Gene trees for ASTRAL

for f in *.80taxadropped.fa; do 
gene=`echo "Locus_$f" | sed 's/\..*//g'`
raxmlHPC-PTHREADS-AVX -f a -m GTRGAMMA -s $f -n $gene -x $RANDOM -p $RANDOM -N 100 -T 10
done


# Concatenate alignments

pxcat -s *.50missing.fa -p partition.50missing.txt -o concatenated.50missing.wholegenus.fasta

# Reformat partition to look like this (no hashtags):

# GTR+G, name = ###-###
# GTR+G, name = ###-###
# GTR+G, name = ###-###

sed -i 's/DNA/GTR+G/g' partition.txt

# Remove high missing data TAXA (this time on the concatenated alignment)

python3 removemissingdatataxa.py concatenated.50missing.wholegenus.fasta concatenated.50missing.80taxadeleted.nickdissertation.fasta 0.2


# Run concatenated tree

raxml-ng -all --model partition.50missing.txt --msa concatenated.50missing.80taxadeleted.wholegenus.fasta --prefix wholegenus --seed $RANDOM --tree pars{10} --threads 40

# Generate input files for ASTRAL
# Combine all gene trees into one file
cat RAxML_bipartitions.Locus* > all_gene_trees.tre
# Check that the gene tree count is correct
wc -l all_gene_trees.tre
# Suppress branches with support less than 10 per ASTRAL documentation
nw_ed  all_gene_trees.tre 'i & b<=10' o > all_gene_trees.bs10.tre
# Download newest ASTRAL
git clone https://github.com/smirarab/ASTRAL
unzip ./ASTRAL/Astral*
rm -rf ASTRAL/
cp all_gene_trees.bs10.tre ./Astral/
cd Astral
# Run ASTRAL
java -jar astral.5.7.8.jar -i all_gene_trees.bs10.tre -o astral.sushilmegatree.tre 2> astral.sushilmegatree.tre.log

