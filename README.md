#Easy Installation and Benchmark of Microbe Detection Computational Methods

Easy installation and benchmark test and evaluation of data analysis methods for microbe detection ([kraken](http://www.baidu.com)(add link), readscan(add link) and cs-score(add link)).
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
give demo output  

## TODO Issues (troubleshooting or FAQ or discussion)
discuss possible errors and how to fix it.

##Files:
install.sh: download and install kraken, readscan and cs-score. 
run.sh: download test data, start computational pipelines to benchmark three methods.

##Contact
Any question could be sent to the following e-mail:
zzh1412@163.com
