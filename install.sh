#install.sh

##install kraken
mkdir kraken
cd kraken

#download the related files
wget https://ccb.jhu.edu/software/kraken/dl/kraken-0.10.5-beta.tgz
wget https://ccb.jhu.edu/software/kraken/dl/minikraken.tgz
wget https://ccb.jhu.edu/software/kraken/dl/accuracy.tgz

#unzip the zip files
tar -zvxf kraken-0.10.5-beta.tgz
tar -zvxf timing.tgz
tar -zvxf accuracy.tgz
tar -zvxf minikraken.tgz

#install the software
cd kraken-0.10.5-beta
./install_kraken.sh ../kraken-software
cd ../../
echo "kraken installation completed"

##install readscan
mkdir readscan
cd readscan

#download the related files
wget http://www.cbrc.kaust.edu.sa/readscan/download/readscan-0.5.tar.gz
wget http://www.cbrc.kaust.edu.sa/readscan/download/human_genome.fasta.gz
wget http://www.cbrc.kaust.edu.sa/readscan/download/fungi_all.fasta.gz
wget http://www.cbrc.kaust.edu.sa/readscan/download/virus_all.fasta.gz
wget http://www.cbrc.kaust.edu.sa/readscan/download/bacterial_all.fasta.gz
wget http://www.cbrc.kaust.edu.sa/readscan/download/microbes.fasta.gz
wget http://www.cbrc.kaust.edu.sa/readscan/download/simulation.fastq.gz
wget http://www.cbrc.kaust.edu.sa/readscan/download/taxon.tar.gz

#unzip the zip files
gunzip bacterial_all.fasta.gz
gunzip chinese_genome.fasta.gz
gunzip fungi_all.fasta.gz
gunzip hs_alt_HuRef.fasta.gz
gunzip human_genome.fasta.gz
gunzip korean_genome.fasta.gz
gunzip microbes.fasta.gz
gunzip protozoa_all.fasta.gz
gunzip simulation.fastq.gz
gunzip virus_all.fasta.gz
tar -zvxf readscan-0.5.tar.gz
tar -zvxf taxon.tar.gz

#install the software
. ./env.sh
cd ..
echo "readscan installation completed"

##install cs-score
mkdir cs-score
cd cs-score

#download the related files
wget http://metagenomics.atc.tcs.com/cscore/application/CSCORE_DISTRIBUTION.7z.001
wget http://metagenomics.atc.tcs.com/cscore/application/CSCORE_DISTRIBUTION.7z.002
wget http://metagenomics.atc.tcs.com/cscore/application/CSCORE_DISTRIBUTION.7z.003
wget http://metagenomics.atc.tcs.com/cscore/application/CSCORE_DISTRIBUTION.7z.004
wget http://metagenomics.atc.tcs.com/cscore/application/CSCORE_DISTRIBUTION.7z.005
wget http://metagenomics.atc.tcs.com/cscore/application/CSCORE_DISTRIBUTION.7z.006

#unzip the files and install the software
7z x CSCORE_DISTRIBUTION.7z.001
tar -xf CSCORE_DISTRIBUTION.tar
unzip sample_big.ffn.zip
cd ..
echo "cs-score installation completed"

echo "All Installation Completed."

#Use these pipelines to analyse the original test cases.
#running kraken
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

echo "Test commited, all the pipelines can work correctly."
echo ""
