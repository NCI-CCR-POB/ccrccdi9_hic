# Running the Pipeline

## Command Options

- dryrun : This is an optional step, to be performed before any Snakemake run (local, cluster). This will check for errors within the pipeline, and ensure that you have read/write access to the files needed to run the full pipeline.
- Processing Commands
    - local: This will run the pipeline on a local node. NOTE: This should only be performed on an interactive node.
    - slurm: This will submit a master job to the cluster, and subsequent sub-jobs as needed to complete the workflow. An email will be sent when the pipeline begins, if there are any errors, and when it completes.
- Other Commands (All optional)
    - unlock: This will unlock the pipeline if an error caused it to stop in the middle of a run.

To run any of these commands, follow the the syntax:

```
# ssh into cluster's head node. An interactive session should be started before performing any of the pipeline sub-commands, even if the pipeline is to be executed on the cluster.

ssh -Y $USER@biowulf.nih.gov

#start interactive node
sinteractive --mem=60g --cpus-per-task=2

# Download or clone this github repo to your directory . For example assume the snakemake project folder is "snakemake_test"

cd /data/CCRCCDI/analysis/ccrtegs9/snakemake_new

#If you wish to do a dry run
bash run_snakemake.sh dryrun /data/CCRCCDI/analysis/ccrtegs9/snakemake_test/

#If you wish to run locally
bash run_snakemake.sh local /data/CCRCCDI/analysis/ccrtegs9/snakemake_test/

#if you wish to run the script on slurm. The pipeline has internal code to insatiate nodes on slurm for the rules.
bash run_snakemake.sh slurm /data/CCRCCDI/analysis/ccrtegs9/snakemake_test/

#If you wish to unlock the folder
bash run_snakemake.sh unlock /data/CCRCCDI/analysis/ccrtegs9/snakemake_test/
```

## 3.3 Setup Dependencies
This pipeline has several dependencies listed below. These dependencies can be installed by a sysadmin. All dependencies will be automatically loaded if running from Biowulf.

- juicer: "juicer/1.6"
- fastqc: "fastqc/0.12.1"
- cutadapt: "cutadapt/4.4
- multiqc: "multiqc/1.20"


### Important parameters to know for running Juicer

* Splitsize: Juicer internally splits the input fastq into smaller fastqs of this size. As you may know, 1 million reads is represented as 4 million reads in the fastq file format. If the splitsize is set to 60 million, each fastq file would contain about 60 million lines covering 15 million reads. We found a splitsize of 60 million to be optimial. `splitsize=60000000`
* Genome version: set to `-g hg38`
* Site: Indicates restriction enzyme. e.g.  "HindIII" or "MboI" . The example dataset in our pipeline was generated using Arima Genomics Hi-C library and hence we set this parameter as `-s Arima`
* Restriction site file: This file includes the locations of
restriction sites in genome; can be generated with the script
misc/generate_site_positions.py. For more information on how to generate this file, refer to https://github.com/aidenlab/juicer/wiki/Usage. 
The example dataset in our pipeline was generated using Arima Genomics Hi-C library and hence we set this parameter as `-y Arima_hg38.txt`
* Setting to include fragment delimited maps: set to true. `-f`

