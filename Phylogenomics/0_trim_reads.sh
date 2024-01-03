
array=( `ls *.fastq.gz | sed 's/_R[12].*//g' | sort | uniq` )

mkdir trimmed

for a in "${array[@]}";
do
java -jar trimmomatic-0.39.jar PE -threads 16 ./${a}_R1.fastq.gz ./${a}_R2.fastq.gz ./trimmed/${a}_P1.fastq ./trimmed/${a}_U1.fastq ./trimmed/${a}_P2.fastq ./trimmed/${a}_U2.fastq ILLUMINACLIP:adapters/TruSeq3-PE.fa:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:36
done
