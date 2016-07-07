#run.sh

#running kraken
#change the fa files to detect other calculation example
echo "Using kraken to verify HiSeq_timing.fa"
cd kraken/kraken-0.10.5-beta/kraken-software
/usr/bin/time -a -o time.log ./kraken --db ../minikraken_20141208 ../HiSeq_timing.fa  2>&1 | tee result.log
tac result.log | sed -n 2p >log
echo -e "The classified sequences occupy \c"
cat log | awk -F"[()]" '{print $2, ORS=""}'
echo " of total sequences."
echo -e "The runnig duration of the kraken is \c"
head -n 1 time.log | awk -F "[user]" '{print $1, ORS=""}'
echo "seconds."
cd ../../../

#testing readscan
#change the fastq files to detect other calculation example
echo "Using readscan to detect simulation.fastq"
cd readscan
. ./env.sh
readscan_makeflow.pl index -k 13 -s 13 human_genome.fasta
readscan_makeflow.pl index -k 13 -s 6 microbes.fasta
readscan_makeflow.pl search -h human_genome -p microbes -r results -T taxon simulation.fastq
cd results/simulation
/usr/bin/time -a -o time.log make -j2 2>&1 | tee result.log
cd output
echo "print (100-" > a.py
nl venn_stats.txt | sed -n '10p' | awk '{print $4, ORS=""}' >> a.py
echo ")" >> a.py
python a.py > log
echo -e "The classified sequences occupy \c"
cat log | awk '{print $0, ORS=""}'
echo " of total sequences."
echo -e "The runnig duration of the readscan is \c"
head -n 1 time.log | awk -F "[user]" '{print $1}'
echo "seconds."
cd ../../

#testing cs-score
#change the fasta files to detect other calculation example
echo "Using cs-score to detect test.fasta"
cd cs-score/CSCORE_DISTRIBUTION
echo "./cscore ./test.fasta" > a.sh
echo "INVALID: "
echo "grep -o INVALID test.fasta.assign | wc -l " >> a.sh
echo "HUMAN: "
echo "grep -o HUMAN test.fasta.assign | wc -l "
echo "PROKARYOTE: "
echo "grep -o PROKARYOTE test.fasta.assign | wc -l "
echo "wc -l test.fasta.assign" >> a.sh
chmod +x a.sh
/usr/bin/time -a -o time.log ./a.sh 2>&1 | tee result.log
echo "print("100* > a.py
tac result.log | sed -n 2p | awk '{print $1, ORS = ""}'>> a.py
echo -e "/\c" >> a.py
tac result.log | sed -n 1p | awk -F "[test]" '{print $1, ORS = ""}' >> a.py
echo -e ")\c" >> a.py
python a.py > log
echo "%" >> log
echo -e "The classified sequences occupy \c"
cat log | awk  '{print $1, ORS=""}'
echo " of total sequences."
echo -e "The runnig duration of the cs-score is \c"
head -n 1 time.log | awk -F "[user]" '{print $1, ORS=""}'
echo "seconds."
cd ../../


