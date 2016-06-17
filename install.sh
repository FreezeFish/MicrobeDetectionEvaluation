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
