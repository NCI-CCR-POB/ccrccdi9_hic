# FruitsC : A CCBR Snakemake Pipeline for HiC data analysis

This snakemake pipeline was developed for genome wide HiC data and uses a popular HiC tool called Juicer. It has been developed by the CCBR team for use in the NIH's Biowulf HPC Cluster and is currently in development mode

## More details about Juicer

The Juicer pipeline was installed and optimized for the NIH's HPC Biowulf cluster by its HPC team. On top of that, the CCBR team has optimized some of the memory settings for the pipeline to run smoothly for very large samples. The largest fastq.gz file executed is about 135-140GB in size (each of the forward and reverse fastq.gz files were close to 70GB)

## About this FruitsC Snakemake Pipeline
This pipeline includes the following steps described below. 

* Quality check of raw fastq reads 
* Trimming low quality reads 
* Check quality of the trimmed reads
* Make a QC HTML report
* Call Juicer HiC tool

The following post-juicer steps are currently under development

* Normalization of hic files
* Call Arrowhead tool to identify contact maps
* Call Hiccups tool 

## How to set up snakemake pipeline

* Step 1: Download the code or clone this github repo. When you download the repo, it will come with all folders with test data already setup. Users will be able to directly run the pipeline on the test data

* Step 2: Run the pipeline with test data. Read: [https://github.com/NCI-CCR-POB/ccrccdi9_hic/blob/main/docs/user-guide/run.md](https://github.com/NCI-CCR-POB/ccrccdi9_hic/blob/main/docs/run.md) 

* Step 3: Examine output files. Read: [https://github.com/NCI-CCR-POB/ccrccdi9_hic/blob/main/docs/user-guide/output.md](https://github.com/NCI-CCR-POB/ccrccdi9_hic/blob/main/docs/output.md) 

* Step 4: Preparing input files for your own data: [Read Preparing-files.md markdown](https://github.com/NCI-CCR-POB/ccrccdi9_hic/blob/main/docs/preparing-files.md)

* Step 5: Run the pipeline with your own data (Same process as Step 2)

## Declarations

This work has been developed and tested solely on NIH [HPC Biowulf](https://hpc.nih.gov/).

## Author contributions

The following members contributed to the development of the this pipeline including source code and logic:

* [Krithika Bhuvaneshwar](https://github.com/krithika_bhuvan)
* Technical advise on snakemake by [Samantha Sevilla Chill](https://github.com/slsevilla)
