#MicrobeDetectionEvaluation

Easy evaluation of three microbe detection data analysis methods.
##Desciption

MicrobeDetectionEvaluation implements two scripts to download and install three microbe detection data analysis methods, which are kraken, readscan and cs-score.<br>

Next-generation sequencing is changing researching methods of biological fields. Microbe detection technologies using next-generation sequencing has the advantages that can response rapidly to biothreat and handle unknown microbes. The large amount data of next-generation sequencing bring problems of high analysis precision and velocity need. In our work, we implemented a simple way to install and run three mainly used microbe detection data analysis methods. <br>
##Install
###Prerequisites
1.Linux OS, our tests are performed on CentOS release 6.5(server) and Ubuntu 15.10(Desktop)<br>
2.Network required. This project will download a lot of related files(>34 Gb) online, please make sure your network is available.<br>
###Download and setup
1.You can use the command line git clone ·https://github.com/FreezeFish/MicrobeDetectionEvaluation.git· to download the project easily.<br>
2.Then you can cd into the MicrobeDetectionEvaluation dir and use the command line chmod +x *.sh, and ./install.sh to configure the detection environment.

##Tools:
install.sh: download kraken, readscan and cs-score, install them and run three analysis examples. <br>
run.sh: download three metagenomics benchmark data, use the pipelines to detect them.

##Contact
Any question could be sent to the following e-mail:
zzh1412@163.com
