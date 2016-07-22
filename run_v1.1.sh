#Download three benchmark data and use the pipelines to evaluate them
#Data: HiSeq_timing.fa, MiSeq_timing.fa simBA5_timing.fa from project kraken

#Create work directory
mkdir benchmark
cd benchmark

#Download the related files
wget http://ccb.jhu.edu/software/kraken/dl/timing.tgz
tar -zvxf timing.tgz

#Use these pipelines to analyse the benchmark data.

#1.Kraken
#Using parameter --threads 1,2,4,8,16 to test the multi-threads performance of Kraken
#Database = Minikraken 4 Gb

#HiSeq for Kraken
mkdir kraken/kraken_results
touch kraken/kraken_results/result_HiSeq.txt
echo "Using kraken to verify HiSeq"
cd kraken/kraken-0.10.5-beta/kraken-software
for x in 1 2 4 8 16
do 
  /usr/bin/time -a -o time$x.log ./kraken --db ../minikraken_20141208 --threads $x ../../../benchmark/HiSeq_timing.fa  2>&1 | tee result$x.log
tac result$x.log | sed -n 2p >tail$x.log
echo "kraken with threads $x:" >> ../../kraken_results/result_HiSeq.txt
echo "accuracy:" >> ../../kraken_results/result_HiSeq.txt
cat tail$x.log | awk -F "[()]" '{print $2, ORS=""}'  >> ../../kraken_results/result_HiSeq.txt
echo "duration:">> ../../kraken_results/result_HiSeq.txt
head -n 1 time$x.log | awk -F "[user]" '{print $1, ORS=""}' >> ../../kraken_results/result_HiSeq.txt
remove *.log
done
cd ../../

#MiSeq for Kraken
echo "Using kraken to verify MiSeq"
touch kraken/kraken_results/result_MiSeq.txt
cd kraken/kraken-0.10.5-beta/kraken-software
for x in 1 2 4 8 16
do 
  /usr/bin/time -a -o time$x.log ./kraken --db ../minikraken_20141208 --threads $x ../../../benchmark/MiSeq_timing.fa  2>&1 | tee result$x.log
tac result$x.log | sed -n 2p >tail$x.log
echo "kraken with threads $x:" >> ../../kraken_results/result_MiSeq.txt
echo "accuracy:" >> ../../kraken_results/result_MiSeq.txt
cat tail$x.log | awk -F "[()]" '{print $2, ORS=""}'  >> ../../kraken_results/result_MiSeq.txt
echo "duration:">> ../../kraken_results/result_MiSeq.txt
head -n 1 time$x.log | awk -F "[user]" '{print $1, ORS=""}' >> ../../kraken_results/result_MiSeq.txt
remove *.log
done
cd ../../

#simBA5 for Kraken
echo "Using kraken to verify simBA5"
touch kraken/kraken_results/result_simBA5.txt
cd kraken/kraken-0.10.5-beta/kraken-software
for x in 1 2 4 8 16
do 
  /usr/bin/time -a -o time$x.log ./kraken --db ../minikraken_20141208 --threads $x ../../../benchmark/simBA5_timing.fa  2>&1 | tee result$x.log
tac result$x.log | sed -n 2p >tail$x.log
echo "kraken with threads $x:" >> ../../kraken_results/result_simBA5.txt
echo "accuracy:" >> ../../kraken_results/kraken_results/result_simBA5.txt
cat tail$x.log | awk -F "[()]" '{print $2, ORS=""}'  >> ../../kraken_results/result_simBA5.txt
echo "duration:">> ../../kraken_results/result_simBA5.txt
head -n 1 time$x.log | awk -F "[user]" '{print $1, ORS=""}' >> ../../kraken_results/result_simBA5.txt
remove *.log
done

echo "Kraken analysis completed."
cd ../../../

#2.Readscan
#Testing the Readscan software on default parameter e.i. k-mer = 13, run 2 jobs simultaneously.
#Preprocessing of Readscan
cd readscan
. ./env.sh
readscan_makeflow.pl index -k 13 -s 13 human_genome.fasta
readscan_makeflow.pl index -k 13 -s 6 microbes.fasta
mkdir readscan_results
#Readscan can only process fastq files, so we need to transform the fasta files into fastq format
#Here we present perl script to do this job, the default quality is set to 25
cd ../benchmark
perl fq_all2std.pl fa2std HiSeq_timing.fa > HiSeq_timing.fastq
perl fq_all2std.pl fa2std MiSeq_timing.fa > MiSeq_timing.fastq
perl fq_all2std.pl fa2std simBA5_timing.fa > simBA5_timing.fastq
cd ../readscan

#HiSeq for Readscan
echo "Using Readscan to detect HiSeq"
readscan_makeflow.pl search -h human_genome -p microbes -r results -T taxon ../benchmark/HiSeq_timing.fastq 
cd results/HiSeq_timing
touch ../readscan_results/result_HiSeq_readscan.txt
/usr/bin/time -a -o time.log make -j2 2>&1 | tee result$x.log cd output
echo "print (100-" > a.py
nl venn_stats.txt | sed -n '10p' | awk '{print $4, ORS=""}' >> a.py
echo ")" >> a.py
python a.py > time$x.log
echo "readscan with threads $x:" >> result_HiSeq_readscan.txt
echo "accuracy: "
cat log | awk '{print $0, ORS=""}' >> result_HiSeq_readscan.txt
echo "duration: "
head -n 1 time$x.log | awk -F "[user]" '{print $1}' >> result_HiSeq_readscan.txt
remove *.log
remove a.py
cd ../

#MiSeq for Readscan
echo "Using Readscan to detect MiSeq"
readscan_makeflow.pl search -h human_genome -p microbes -r results -T taxon ../benchmark/MiSeq_timing.fastq 
cd results/MiSeq_timing
touch ../readscan_results/result_MiSeq_readscan.txt
/usr/bin/time -a -o time.log make -j2 2>&1 | tee result$x.log cd output
echo "print (100-" > a.py
nl venn_stats.txt | sed -n '10p' | awk '{print $4, ORS=""}' >> a.py
echo ")" >> a.py
python a.py > time$x.log
echo "readscan with threads $x:" >> result_MiSeq_readscan.txt
echo "accuracy: "
cat log | awk '{print $0, ORS=""}' >> result_MiSeq_readscan.txt
echo "duration: "
head -n 1 time$x.log | awk -F "[user]" '{print $1}' >> result_MiSeq_readscan.txt
remove *.log
remove a.py
cd ../

#simBA5 for Readscan
echo "Using Readscan to detect simBA5"
readscan_makeflow.pl search -h human_genome -p microbes -r results -T taxon ../benchmark/simBA5_timing.fastq 
cd results/simBA5_timing
touch ../readscan_results/result_simBA5_readscan.txt
/usr/bin/time -a -o time.log make -j2 2>&1 | tee result$x.log cd output
echo "print (100-" > a.py
nl venn_stats.txt | sed -n '10p' | awk '{print $4, ORS=""}' >> a.py
echo ")" >> a.py
python a.py > time$x.log
echo "readscan with threads $x:" >> result_simBA5_readscan.txt
echo "accuracy: "
cat log | awk '{print $0, ORS=""}' >> result_simBA5_readscan.txt
echo "duration: "
head -n 1 time$x.log | awk -F "[user]" '{print $1}' >> result_simBA5_readscan.txt
remove *.log
remove a.py
cd ../

#3.CS-SCORE
#CS-SCORE doesn't supply adjustable parameter or mode to adjust the processing or multi-threads work pattern.

#HiSeq for CS-SCORE
cd cs-score/CSCORE_DISTRIBUTION
echo "./cscore ../../benchmark/HiSeq_timing.fa" > a.sh
echo "INVALID: "
echo "grep -o INVALID ../../benchmark/HiSeq_timing.fa.assign | wc -l " >> a.sh
echo "HUMAN: "
echo "grep -o HUMAN ../../benchmark/HiSeq_timing.fa.assign | wc -l "
echo "PROKARYOTE: "
echo "grep -o PROKARYOTE ../../benchmark/HiSeq_timing.fa.assign | wc -l "
echo "wc -l ../../benchmark/HiSeq_timing.fa.assign" >> a.sh
chmod +x a.sh
/usr/bin/time -a -o time.log ./a.sh 2>&1 | tee result.log
echo "print("100* > a.py
tac result.log | sed -n 2p | awk '{print $1, ORS = ""}'>> a.py
echo -e "/\c" >> a.py
tac result.log | sed -n 1p | awk -F "[test]" '{print $1, ORS = ""}' >> a.py
echo -e ")\c" >> a.py
python a.py > result.log
echo "%" >> result.log
echo "cs-score: HiSeq" > cs-score_HiSeq_result.txt
echo "accuracy:" >> cs-score_HiSeq_result.txt
cat result.log | awk  '{print $1, ORS=""}' >> cs-score_HiSeq_result.txt
echo "duration:" >> cs-score_HiSeq_result.txt
head -n 1 time.log | awk -F "[user]" '{print $1, ORS=""}' >> cs-score_HiSeq_result.txt
remove *.log
remove a.py

#MiSeq for CS-SCORE
cd cs-score/CSCORE_DISTRIBUTION
echo "./cscore ../../benchmark/MiSeq_timing.fa" > a.sh
echo "INVALID: "
echo "grep -o INVALID ../../benchmark/MiSeq_timing.fa.assign | wc -l " >> a.sh
echo "HUMAN: "
echo "grep -o HUMAN ../../benchmark/MiSeq_timing.fa.assign | wc -l "
echo "PROKARYOTE: "
echo "grep -o PROKARYOTE ../../benchmark/MiSeq_timing.fa.assign | wc -l "
echo "wc -l ../../benchmark/MiSeq_timing.fa.assign" >> a.sh
chmod +x a.sh
/usr/bin/time -a -o time.log ./a.sh 2>&1 | tee result.log
echo "print("100* > a.py
tac result.log | sed -n 2p | awk '{print $1, ORS = ""}'>> a.py
echo -e "/\c" >> a.py
tac result.log | sed -n 1p | awk -F "[test]" '{print $1, ORS = ""}' >> a.py
echo -e ")\c" >> a.py
python a.py > result.log
echo "%" >> result.log
echo "cs-score: MiSeq" > cs-score_MiSeq_result.txt
echo "accuracy:" >> cs-score_MiSeq_result.txt
cat result.log | awk  '{print $1, ORS=""}' >> cs-score_MiSeq_result.txt
echo "duration:" >> cs-score_MiSeq_result.txt
head -n 1 time.log | awk -F "[user]" '{print $1, ORS=""}' >> cs-score_MiSeq_result.txt
remove *.log
remove a.py

#simBA5 for CS-SCORE
cd cs-score/CSCORE_DISTRIBUTION
echo "./cscore ../../benchmark/simBA5_timing.fa" > a.sh
echo "INVALID: "
echo "grep -o INVALID ../../benchmark/simBA5_timing.fa.assign | wc -l " >> a.sh
echo "HUMAN: "
echo "grep -o HUMAN ../../benchmark/simBA5_timing.fa.assign | wc -l "
echo "PROKARYOTE: "
echo "grep -o PROKARYOTE ../../benchmark/simBA5_timing.fa.assign | wc -l "
echo "wc -l ../../benchmark/simBA5_timing.fa.assign" >> a.sh
chmod +x a.sh
/usr/bin/time -a -o time.log ./a.sh 2>&1 | tee result.log
echo "print("100* > a.py
tac result.log | sed -n 2p | awk '{print $1, ORS = ""}'>> a.py
echo -e "/\c" >> a.py
tac result.log | sed -n 1p | awk -F "[test]" '{print $1, ORS = ""}' >> a.py
echo -e ")\c" >> a.py
python a.py > result.log
echo "%" >> result.log
echo "cs-score: simBA5" > cs-score_HiSeq_result.txt
echo "accuracy:" >> cs-score_simBA5_result.txt
cat result.log | awk  '{print $1, ORS=""}' >> cs-score_simBA5_result.txt
echo "duration:" >> cs-score_simBA5_result.txt
head -n 1 time.log | awk -F "[user]" '{print $1, ORS=""}' >> cs-score_simBA5_result.txt
remove *.log
remove a.py
cd ../../

#Finish the runs
