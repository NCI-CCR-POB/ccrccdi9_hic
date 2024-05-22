#!/bin/bash

#### Settings for HPC - remove if not relevant
#SBATCH --job-name=hic_validate
#SBATCH --time=48:00:00
#SBATCH --mem=40gb
#SBATCH --gres=lscratch:200
#SBATCH --cpus-per-task=4

## TITLE: After juicer completes, run juicer tools validate


#ALIGNED="/data/CCRCCDI/analysis/ccrtegs9/02_call_juicer_on_trimmed/Run2/snakemake_test/results/out_juicer/TDOX/aligned/"
ALIGNED=$1

echo $ALIGNED

module load juicer

juicer_tools validate $ALIGNED"/inter.hic" > $ALIGNED"/validate_interhic.txt"

juicer_tools validate $ALIGNED"/inter_30.hic" > $ALIGNED"/validate_interhic30.txt"
    
done

#how to run script
# Step1 - cd to the snakemake scripts directory
# Step 2 - call the postjuicer_01_validate.sh and pass the full path to the location of the "aligned" folder. Example shown below

#cd /dataCCRCCDI/analysis/ccrtegs9/02_call_juicer_on_trimmed/Run2/snakemake_test/workflow/scripts

#sbatch postjuicer_01_validate.sh "/data/CCRCCDI/analysis/ccrtegs9/02_call_juicer_on_trimmed/Run2/snakemake_test/results/out_juicer/TDOX/aligned/"
