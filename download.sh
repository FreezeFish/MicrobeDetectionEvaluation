#This file is used to download the benchmark data
mkdir benchmark
cd benchmark



#download the related files
mkdir small_data
cd small_data
wget http://www.cbrc.kaust.edu.sa/readscan/download/simulation.fastq.gz
gunzip simulation.fastq.gz
cd ..

mkdir middle_data
cd middle_data
wget http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?cmd=dload&run_list=ERR205979&format=fastq
gunzip sra_data.fastq.gz
cd ..

mkdir large_data
cd large_data
wget http://
gunzip
cd ..

