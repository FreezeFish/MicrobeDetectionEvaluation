#This file is used to download the benchmark data
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

