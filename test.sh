#run.sh

#testing kraken
#change the fa files to detect other calculation example
echo "Using kraken to verify HiSeq_timing.fa"
cd kraken/kraken-0.10.5-beta/kraken-software
./kraken --db ../minikraken_20141208 ../HiSeq_timing.fa 
cd ../../../

#testing readscan
#change the fastq files to detect other calculation example
echo "Using readscan to detect simulation.fastq"
cd readscan
. ./env.sh
readscan_makeflow.pl index -k 13 -s 13 human_genome.fasta
readscan_makeflow.pl index -k 13 -s 6 microbes.fasta
readscan_makeflow.pl search -h human_genome -p microbes -r results -T taxon simulation.fastq
cd results
make -j2
cd ../../

#testing cs-score
#change the fasta files to detect other calculation example
echo "Using cs-score to detect test.fasta"
cd cs-score/CSCORE_DISTRIBUTION
./cscore ./test.fasta
cd ../../


