#Download three benchmark data and use the pipelines to evaluate them
mkdir benchmark
cd benchmark

#download the related files
mkdir small_data
cd small_data
wget http://www.cbrc.kaust.edu.sa/readscan/download/simulation.fastq.gz
gunzip simulation.fastq.gz
mv simulation.fastq small_data.fastq
cd ..

mkdir middle_data
cd middle_data
wget http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?cmd=dload&run_list=SRR453448&format=fastq
gunzip sra_data.fastq.gz
mv sra_data.fastq middle_data.fastq
cd ..

mkdir large_data
cd large_data
wget http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?cmd=dload&run_list=ERR205979&format=fastq
gunzip gunzip sra_data.fastq.gz
mv sra_data.fastq large_data.fastq
cd ..

#Use these pipelines to analyse the benchmark data.
#kraken
echo "Using kraken to verify small_data.fastq"
cd kraken/kraken-0.10.5-beta/kraken-software
/usr/bin/time -a -o time1.log ./kraken --db ../minikraken_20141208 --threads 1 ../benchmark/small_data/small_data.fastq  2>&1 | tee result1.log
tac result1.log | sed -n 2p >tail1.log
echo "small_data.fastq" > result_kraken_small.txt
echo "kraken with threads 1:" >> result_kraken_small.txt
echo "accuracy:">> result_kraken_small.txt
cat tail1.log | awk -F"[()]" '{print $2, ORS=""}'  >> result_kraken_small.txt
echo "duration:">> result_kraken_small.txt
head -n 1 time1.log | awk -F "[user]" '{print $1, ORS=""}' >> result_kraken_small.txt
remove *.log

for x in 2 4 8
do 
  /usr/bin/time -a -o time$x.log ./kraken --db ../minikraken_20141208 --threads $x ../benchmark/small_data/small_data.fastq  2>&1 | tee result$x.log
tac result$x.log | sed -n 2p >tail$x.log
echo "kraken with threads $x:" >> result_kraken_small.txt
echo "accuracy:">> >> result_kraken_small.txt
cat tail$x.log | awk -F"[()]" '{print $2, ORS=""}'  >> result_kraken_small.txt
echo "duration:">> result_kraken_small.txt
head -n 1 time$x.log | awk -F "[user]" '{print $1, ORS=""}' >> result_kraken_small.txt
remove *.log
done

:'
/usr/bin/time -a -o time2.log ./kraken --db ../minikraken_20141208 --threads 2 ../benchmark/small_data/small_data.fastq  2>&1 | tee result2.log
tac result2.log | sed -n 2p >tail2.log
echo "kraken with threads 2:" >> result_kraken_small.txt
echo "accuracy:">> >> result_kraken_small.txt
cat tail2.log | awk -F"[()]" '{print $2, ORS=""}'  >> result_kraken_small.txt
echo "duration:">> result_kraken_small.txt
head -n 1 time2.log | awk -F "[user]" '{print $1, ORS=""}' >> result_kraken_small.txt
remove *.log

/usr/bin/time -a -o time4.log ./kraken --db ../minikraken_20141208 --threads 4 ../benchmark/small_data/small_data.fastq  2>&1 | tee result4.log
tac result4.log | sed -n 2p >tail4.log
echo "kraken with threads 4:" >> result_kraken_small.txt
echo "accuracy:">> result_kraken_small.txt
cat tail1.log | awk -F"[()]" '{print $2, ORS=""}'  >> result_kraken_small.txt
echo "duration:">> result_kraken_small.txt
head -n 1 time4.log | awk -F "[user]" '{print $1, ORS=""}' >> result_kraken_small.txt
remove *.log

/usr/bin/time -a -o time8.log ./kraken --db ../minikraken_20141208 --threads 8 ../benchmark/small_data/small_data.fastq  2>&1 | tee result8.log
tac result1.log | sed -n 2p >tail8.log
echo "kraken with threads 8:" >> result_kraken_small.txt
echo "accuracy:">> result_kraken_small.txt
cat tail1.log | awk -F"[()]" '{print $2, ORS=""}'  >> result_kraken_small.txt
echo "duration:">> result_kraken_small.txt
head -n 1 time1.log | awk -F "[user]" '{print $1, ORS=""}'>> result_kraken_small.txt
remove *.log
'









cd ../../../
#testing readscan
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
