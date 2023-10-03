mkdir consensus_sequences
mkdir tmp

bwa index NC_050667.symphyotrichum_subulatum.oneIR.fasta

# New data batch

for file_R1 in /mnt/Heuheu/Symphyotrichum/symphyotrichum_NovogeneMay2021/trimmed/*_P1.fastq; do
name=`echo $file_R1 | sed 's/_P1\..*//g' | sed 's/.*\///g'`

bwa mem -t 4 NC_050667.symphyotrichum_subulatum.oneIR.fasta /mnt/Heuheu/Symphyotrichum/symphyotrichum_NovogeneMay2021/trimmed/${name}_P1.fastq  /mnt/Heuheu/Symphyotrichum/symphyotrichum_NovogeneMay2021/trimmed/${name}_P2.fastq > ${name}.temp.cp.sam

# Make sure to set haploid for chloroplast data
samtools sort -T ./tmp/${name}.aln.cp.sorted -o ${name}.temp.cp.bam ${name}.temp.cp.sam
samtools mpileup -uf NC_050667.symphyotrichum_subulatum.oneIR.fasta ${name}.temp.cp.bam > ${name}.bcf.cp.tmp
bcftools call --ploidy 1 -c ${name}.bcf.cp.tmp | vcfutils.pl vcf2fq > ./consensus_sequences/${name}.cp.consensus.fq
rm ${name}.temp.cp.sam ${name}.temp.cp.bam ${name}.bcf.cp.tmp ./tmp/${name}.aln.cp.sorted*

done


