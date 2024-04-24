# Testing the Pipeline

When you download the repo, it will come with all folders with test data already setup. Users will be able to directly run the pipeline on the test data

## How to test the pipeline

```
# ssh into cluster's head node. An interactive session should be started before performing any of the pipeline sub-commands, even if the pipeline is to be executed on the cluster.

ssh -Y $USER@biowulf.nih.gov

#start interactive node
sinteractive --mem=80g --cpus-per-task=4

# If not already, download or clone this github repo to your directory . For example assume the snakemake project folder is `snakemake_test`

# Change directory
cd /data/CCRCCDI/analysis/ccrtegs9/snakemake_new

#Do do a dry run
bash run_snakemake.sh dryrun /data/CCRCCDI/analysis/ccrtegs9/snakemake_test/

#If you wish to run locally
bash run_snakemake.sh local /data/CCRCCDI/analysis/ccrtegs9/snakemake_test/

#if you wish to run the script on slurm. The pipeline has internal code to insatiate nodes on slurm for the rules.
bash run_snakemake.sh slurm /data/CCRCCDI/analysis/ccrtegs9/snakemake_test/

#If you wish to unlock the folder
bash run_snakemake.sh unlock /data/CCRCCDI/analysis/ccrtegs9/snakemake_test/
```

## Output files after testing

The output of the pipeline run will be sent to the `results` folder within the snakemake pipeline.

A backup copy of the output files has been made available in the snakemake project folder `testing/test_results` so users can see the expected output folders and results

For more details on the expected output folders please read this document:



