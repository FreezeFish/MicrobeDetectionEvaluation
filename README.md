#Easy Installation and Benchmark of Microbe Detection Computational Methods

Easy installation and benchmark test and evaluation of data analysis methods for microbe detection ([kraken](https://ccb.jhu.edu/software/kraken/), [readscan](http://cbrc.kaust.edu.sa/readscan/) and [cs-score](http://metagenomics.atc.tcs.com/preprocessing/cs-score/)).
##Desciption

Next-generation sequencing is changing research methods in biological sciences and applications. As one of culture-independent methods  Microbe detection using next-generation sequencing takes advantages of rapid responses to unknown microbes. The large amount of NGS data need fast, flexible and reliable data analysis methods. As widely used analysis methods of microbe detection, we implemented a set of shell scripts for installation and benchmark kraken, readscan and cs-score computational methods automaticlly. 

##Install
###Prerequisites
1. Linux OS, tested on CentOS release 6.5 (server) and Ubuntu 15.10 (Desktop)
2. Network. During the installation, large amount of sequence and annotation database files(>34 Gb) will download from online web server, please make sure your network is available.

###Download and setup
1. Run `git clone https://github.com/FreezeFish/MicrobeDetectionEvaluation.git` to download the shell scripts.
2. Run `cd MicrobeDetectionEvaluation && . ./install.sh` to configure the environment.
3. Run `. ./run.sh` to start benchmark evaluation.

## TODO output
demo output:  
kraken with threads 1:<br>
accuracy:<br>
96.52%<br>
duration:<br>
5.01<br>
kraken with threads 2:<br>
accuracy:<br>
96.52%<br>
duration:<br>
7.08<br>
kraken with threads 4:<br>
accuracy:<br>
96.52%<br>
duration:<br>
10.71<br>
kraken with threads 8:<br>
accuracy:<br>
96.52%<br>
duration:<br>
11.4<br>

## TODO Issues (troubleshooting or FAQ or discussion)
discuss possible errors and how to fix it.
1.Readscan software cannot deal with fasta files.
2.CS-SCORE core dumped, faststop. Use fq2fa to convert the fastq file into fasta, then use CS-SCORE
3.

##Files:
install.sh: download and install kraken, readscan and cs-score. <br>
run.sh: download test data, start computational pipelines to benchmark three methods.<br>
fq2fa: executable file to convert fastq files into fasta file. Usage: fq2fa *.fastq *.fasta

##Contact
Any question could be sent to the following e-mail:
zzh1412@163.com
