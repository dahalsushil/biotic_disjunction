# start with whole_genus alignments
for f in *.aligned.fa; do  seqtk seq $f > $f.singleline.fa; done

bash exclude_list_ASTRAL.sh

# Remove high missing data SITES
for f in *.singleline.fa; do 
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

pxcat -s *.50missing.fa -p partition.50missing.txt -o concatenated.50missing.virgulus.fasta

# Reformat partition to look like this (no hashtags):

# GTR+G, name = ###-###
# GTR+G, name = ###-###
# GTR+G, name = ###-###

sed -i 's/DNA/GTR+G/g' partition.50missing.txt

# Remove high missing data TAXA (this time on the concatenated alignment)

python3 removemissingdatataxa.py concatenated.50missing.virgulus.fasta concatenated.50missing.80taxadeleted.virgulus.fasta 0.2


# Run concatenated tree

raxml-ng -all --model partition.50missing.txt --msa concatenated.50missing.80taxadeleted.virgulus.fasta --prefix subg.virgulus --seed $RANDOM --tree pars{10} --threads 40

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
