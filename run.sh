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
mkdir kraken/kraken_results
touch kraken/kraken_results/result_kraken_small.txt
echo "Using kraken to verify small_data.fastq"
cd kraken/kraken-0.10.5-beta/kraken-software
for x in 1 2 4 8
do 
  /usr/bin/time -a -o time$x.log ./kraken --db ../minikraken_20141208 --threads $x ../../../benchmark/small_data/small_data.fastq  2>&1 | tee result$x.log
tac result$x.log | sed -n 2p >tail$x.log
echo "kraken with threads $x:" >> ../../kraken_results/result_kraken_small.txt
echo "accuracy:" >> ../../kraken_results/result_kraken_small.txt
cat tail$x.log | awk -F"[()]" '{print $2, ORS=""}'  >> ../../kraken_results/result_kraken_small.txt
echo "duration:">> ../../kraken_results/result_kraken_small.txt
head -n 1 time$x.log | awk -F "[user]" '{print $1, ORS=""}' >> ../../kraken_results/result_kraken_small.txt
remove *.log
done

echo "Using kraken to verify middle_data.fastq"
cd kraken/kraken-0.10.5-beta/kraken-software
for x in 1 2 4 8
do 
  /usr/bin/time -a -o time$x.log ./kraken --db ../minikraken_20141208 --threads $x ../../../benchmark/middle_data/middle_data.fastq  2>&1 | tee result$x.log
tac result$x.log | sed -n 2p >tail$x.log
echo "kraken with threads $x:" >> ../../kraken_results/result_kraken_middle.txt
echo "accuracy:" >> ../../kraken_results/result_kraken_middle.txt
cat tail$x.log | awk -F"[()]" '{print $2, ORS=""}'  >> ../../kraken_results/result_kraken_middle.txt
echo "duration:">> ../../kraken_results/result_kraken_middle.txt
head -n 1 time$x.log | awk -F "[user]" '{print $1, ORS=""}' >> ../../kraken_results/result_kraken_middle.txt
remove *.log
done

echo "Using kraken to verify large_data.fastq"
cd kraken/kraken-0.10.5-beta/kraken-software
for x in 1 2 4 8
do 
  /usr/bin/time -a -o time$x.log ./kraken --db ../minikraken_20141208 --threads $x ../../../benchmark/large_data/large_data.fastq  2>&1 | tee result$x.log
tac result$x.log | sed -n 2p >tail$x.log
echo "kraken with threads $x:" >> ../../kraken_results/result_kraken_large.txt
echo "accuracy:" >> ../../kraken_results/result_kraken_large.txt
cat tail$x.log | awk -F"[()]" '{print $2, ORS=""}'  >> ../../kraken_results/result_kraken_large.txt
echo "duration:">> ../../kraken_results/result_kraken_large.txt
head -n 1 time$x.log | awk -F "[user]" '{print $1, ORS=""}' >> ../../kraken_results/result_kraken_large.txt
remove *.log
done

echo "Kraken analysis completed."
cd ../../../



#readscan
echo "Using readscan to detect small_data.fastq"
cd readscan
. ./env.sh
readscan_makeflow.pl index -k 13 -s 13 human_genome.fasta
readscan_makeflow.pl index -k 13 -s 6 microbes.fasta
readscan_makeflow.pl search -h human_genome -p microbes -r results -T taxon ../benchmark/small_data/small_data.fastq

mkdir readscan_results

cd results/small_data
touch ../readscan_results/result_small_readscan.txt
for x in 1,2,4,8
do
/usr/bin/time -a -o time.log make -j$x 2>&1 | tee result$x.log
cd output
echo "print (100-" > a.py
nl venn_stats.txt | sed -n '10p' | awk '{print $4, ORS=""}' >> a.py
echo ")" >> a.py
python a.py > time$x.log
echo "readscan with threads $x:" >> result_small_readscan.txt
echo "accuracy: "
cat log | awk '{print $0, ORS=""}' >> result_small_readscan.txt
echo "duration: "
head -n 1 time$x.log | awk -F "[user]" '{print $1}' >> result_small_readscan.txt
remove *.log
remove a.py
done
cd ../

cd results/middle_data
touch ../readscan_results/result_middle_readscan.txt
for x in 1,2,4,8
do
/usr/bin/time -a -o time.log make -j$x 2>&1 | tee result$x.log
cd output
echo "print (100-" > a.py
nl venn_stats.txt | sed -n '10p' | awk '{print $4, ORS=""}' >> a.py
echo ")" >> a.py
python a.py > time$x.log
echo "readscan with threads $x:" >> result_middle_readscan.txt
echo "accuracy: "
cat log | awk '{print $0, ORS=""}' >> result_middle_readscan.txt
echo "duration: "
head -n 1 time$x.log | awk -F "[user]" '{print $1}' >> result_middle_readscan.txt
remove *.log
remove a.py
done
cd ../

cd results/large_data
touch ../readscan_results/result_large_readscan.txt
for x in 1,2,4,8
do
/usr/bin/time -a -o time.log make -j$x 2>&1 | tee result$x.log
cd output
echo "print (100-" > a.py
nl venn_stats.txt | sed -n '10p' | awk '{print $4, ORS=""}' >> a.py
echo ")" >> a.py
python a.py > time$x.log
echo "readscan with threads $x:" >> result_large_readscan.txt
echo "accuracy: "
cat log | awk '{print $0, ORS=""}' >> result_large_readscan.txt
echo "duration: "
head -n 1 time$x.log | awk -F "[user]" '{print $1}' >> result_large_readscan.txt
remove *.log
remove a.py
done
cd ../../



#cs-score
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
