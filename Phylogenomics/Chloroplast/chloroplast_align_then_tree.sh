rm combined_cps.fq # Remove residual files if this is run more than once due to a problem



for f in ./consensus_sequences/*.fq; do
seqtk seq -l0 ${f} > temp.fq # Convert to four-line fastq format if necessary
seqtk seq -a temp.fq > ${f}.fa # Convert to fasta
done

for f in ./consensus_sequences/*.fa; do
g=`echo $f | sed 's/\.cp\.consensus\.fq\.fa//'g | sed 's/.*\///g'`
#echo $g
sed -i "s/>.*/>${g}/" ${f} # Assign sample names
done

cat ./consensus_sequences/*.fa > ./combined_cps.fasta
rm ./consensus_sequences/*.fa ./temp.fq

# Stop here and open in MEGAX, import as alignment then export
#mafft --thread -4 --op 3 --ep 0.123 --auto combined_cps.fasta > combined_cps.aligned.fa; # Run mafft, allowing it to decide best parameters
# I used to align but the program outputs already aligned sequence -- MEGAX is to take care of filling in the ends of the sequences with Ns

raxml-ng -all --model GTR+G --msa combined_cps.aligned.fa --prefix chloroplast --seed $RANDOM --tree pars{10} --bs-trees 100 --threads 10
