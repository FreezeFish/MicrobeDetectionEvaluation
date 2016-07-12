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
cd kraken/kraken-software
for x in 1 2 4 8
do 
  /usr/bin/time -a -o time$x.log ./kraken --db ../minikraken_20141208 --threads $x ../../benchmark/small_data/small_data.fastq  2>&1 | tee result$x.log
tac result$x.log | sed -n 2p >tail$x.log
echo "kraken with threads $x:" >> ../kraken_results/result_kraken_small.txt
echo "accuracy:" >> ../kraken_results/result_kraken_small.txt
cat tail$x.log | awk -F"[()]" '{print $2}'  >> ../kraken_results/result_kraken_small.txt
echo "duration:">> ../kraken_results/result_kraken_small.txt
head -n 1 time$x.log | awk -F "[user]" '{print $1}' >> ../kraken_results/result_kraken_small.txt
rm *.log
done


touch kraken/kraken_results/result_kraken_middle.txt
echo "Using kraken to verify middle_data.fastq"
cd kraken/kraken-software
for x in 1 2 4 8
do 
  /usr/bin/time -a -o time$x.log ./kraken --db ../minikraken_20141208 --threads $x ../../benchmark/middle_data/middle_data.fastq  2>&1 | tee result$x.log
tac result$x.log | sed -n 2p >tail$x.log
echo "kraken with threads $x:" >> ../kraken_results/result_kraken_middle.txt
echo "accuracy:" >> ../kraken_results/result_kraken_middle.txt
cat tail$x.log | awk -F"[()]" '{print $2}'  >> ../kraken_results/result_kraken_middle.txt
echo "duration:">> ../kraken_results/result_kraken_small.txt
head -n 1 time$x.log | awk -F "[user]" '{print $1}' >> ../kraken_results/result_kraken_middle.txt
rm *.log
done


touch kraken/kraken_results/result_kraken_large.txt
echo "Using kraken to verify large_data.fastq"
cd kraken/kraken-software
for x in 1 2 4 8
do 
  /usr/bin/time -a -o time$x.log ./kraken --db ../minikraken_20141208 --threads $x ../../benchmark/large_data/large_data.fastq  2>&1 | tee result$x.log
tac result$x.log | sed -n 2p >tail$x.log
echo "kraken with threads $x:" >> ../kraken_results/result_kraken_large.txt
echo "accuracy:" >> ../kraken_results/result_kraken_large.txt
cat tail$x.log | awk -F"[()]" '{print $2}'  >> ../kraken_results/result_kraken_large.txt
echo "duration:">> ../kraken_results/result_kraken_large.txt
head -n 1 time$x.log | awk -F "[user]" '{print $1}' >> ../kraken_results/result_kraken_large.txt
rm *.log
done

echo "Kraken analysis completed."
cd ../../../




#readscan
echo "Using readscan to detect small_data.fastq"
cd readscan/readscan
. ./env.sh
cd ..
mkdir results
readscan_makeflow.pl index -k 13 -s 13 human_genome.fasta
readscan_makeflow.pl index -k 13 -s 6 microbes.fasta
readscan_makeflow.pl search -h human_genome -p microbes -r results -T taxon ../benchmark/small_data/small_data.fastq

mkdir readscan_results

cd results/small_data
touch ../../readscan_results/result_small_readscan.txt
/usr/bin/time -a -o time.log make -j2
cd output
echo "print (100-" > a.py
nl venn_stats.txt | sed -n '10p' | awk '{print $4, ORS=""}' >> a.py
echo ")" >> a.py
python a.py > accuracy.log
echo "readscan results:" >> ../../../readscan_results/result_small_readscan.txt
echo "accuracy: "  >> ../../../readscan_results/result_small_readscan.txt
cat accuracy.log | awk '{print $0}' >> ../../../readscan_results/result_small_readscan.txt
echo "duration: " >> ../../../readscan_results/result_small_readscan.txt
head -n 1 ../time.log | awk -F "[user]" '{print $1}' >> ../../../readscan_results/result_small_readscan.txt
rm *.log
rm a.py
cd ../

readscan_makeflow.pl search -h human_genome -p microbes -r results -T taxon ../benchmark/middle_data/middle_data.fastq

cd results/middle_data
touch ../../readscan_results/result_middle_readscan.txt
/usr/bin/time -a -o time.log make -j2
cd output
echo "print (100-" > a.py
nl venn_stats.txt | sed -n '10p' | awk '{print $4, ORS=""}' >> a.py
echo ")" >> a.py
python a.py > accuracy.log
echo "readscan results:" >> ../../../readscan_results/result_middle_readscan.txt
echo "accuracy: "  >> ../../../readscan_results/result_middle_readscan.txt
cat accuracy.log | awk '{print $0}' >> ../../../readscan_results/result_middle_readscan.txt
echo "duration: " >> ../../../readscan_results/result_middle_readscan.txt
head -n 1 ../time.log | awk -F "[user]" '{print $1}' >> ../../../readscan_results/result_middle_readscan.txt
rm *.log
rm a.py
cd ../

readscan_makeflow.pl search -h human_genome -p microbes -r results -T taxon ../benchmark/large_data/large_data.fastq

cd results/large_data
touch ../../readscan_results/result_large_readscan.txt
/usr/bin/time -a -o time.log make -j2
cd output
echo "print (100-" > a.py
nl venn_stats.txt | sed -n '10p' | awk '{print $4, ORS=""}' >> a.py
echo ")" >> a.py
python a.py > accuracy.log
echo "readscan results:" >> ../../../readscan_results/result_large_readscan.txt
echo "accuracy: "  >> ../../../readscan_results/result_large_readscan.txt
cat accuracy.log | awk '{print $0}' >> ../../../readscan_results/result_large_readscan.txt
echo "duration: " >> ../../../readscan_results/result_large_readscan.txt
head -n 1 ../time.log | awk -F "[user]" '{print $1}' >> ../../../readscan_results/result_large_readscan.txt
rm *.log
rm a.py
cd ../


#cs-score
#cs-score doesn't apply multi-threads work pattern.
cd cs-score/CSCORE_DISTRIBUTION
rm a.py
/usr/bin/time -a -o time.log ./cscore ../../benchmark/small_data/small_data.fastq
#echo "grep -o HUMAN ../../benchmark/small_data/small_data.fastq.assign | wc -l "
#echo "grep -o PROKARYOTE ../../benchmark/small_data/small_data.fastq.fasta.assign | wc -l "
#echo "wc -l ../../benchmark/small_data/small_data.fastq.assign" >> a.sh
#chmod +x a.sh
#/usr/bin/time -a -o time.log ./a.sh 2>&1 | tee result.log
echo "print(100*(1-" > a.py
grep -o INVALID ../../benchmark/small_data/small_data.fastq.assign | wc -l | awk '{print $1, ORS=""}'>> a.py
echo -e "/" >> a.py
wc -l ../../benchmark/small_data/small_data.fastq.assign | awk '{print $1, ORS=""}'>> a.py
echo -e "))\c" >> a.py
python a.py > result1.log
echo "%" >> result1.log
echo "cs-score: small_data.fastq" > cs-score_small_data.txt
echo "accuracy:" >> cs-score_small_data.txt
cat result1.log | awk  '{print $1, ORS=""}' >> cs-score_small_data.txt
echo "duration:" >> cs-score_small_data.txt
head -n 1 time.log | awk -F "[user]" '{print $1, ORS=""}' >> cs-score_small_data.txt
rm *.log
rm a.py

cd cs-score/CSCORE_DISTRIBUTION
rm a.py
/usr/bin/time -a -o time.log ./cscore ../../benchmark/middle_data/middle_data.fastq
echo "print(100*(1-" > a.py
grep -o INVALID ../../benchmark/middle_data/middle_data.fastq.assign | wc -l | awk '{print $1, ORS=""}'>> a.py
echo -e "/" >> a.py
wc -l ../../benchmark/middle_data/middle_data.fastq.assign | awk '{print $1, ORS=""}'>> a.py
echo -e "))\c" >> a.py
python a.py > result1.log
echo "%" >> result1.log
echo "cs-score: middle_data.fastq" > cs-score_middle_data.txt
echo "accuracy:" >> cs-score_small_data.txt
cat result1.log | awk  '{print $1, ORS=""}' >> cs-score_middle_data.txt
echo "duration:" >> cs-score_middle_data.txt
head -n 1 time.log | awk -F "[user]" '{print $1, ORS=""}' >> cs-score_middle_data.txt
rm *.log
rm a.py

cd cs-score/CSCORE_DISTRIBUTION
rm a.py
/usr/bin/time -a -o time.log ./cscore ../../benchmark/large_data/large_data.fastq
echo "print(100*(1-" > a.py
grep -o INVALID ../../benchmark/large_data/large_data.fastq.assign | wc -l | awk '{print $1, ORS=""}'>> a.py
echo -e "/" >> a.py
wc -l ../../benchmark/large_data/large_data.fastq.assign | awk '{print $1, ORS=""}'>> a.py
echo -e "))\c" >> a.py
python a.py > result1.log
echo "%" >> result1.log
echo "cs-score: large_data.fastq" > cs-score_large_data.txt
echo "accuracy:" >> cs-score_large_data.txt
cat result1.log | awk  '{print $1, ORS=""}' >> cs-score_large_data.txt
echo "duration:" >> cs-score_large_data.txt
head -n 1 time.log | awk -F "[user]" '{print $1, ORS=""}' >> cs-score_large_data.txt
rm *.log
rm a.py

cd ../../

#Finish the runs


