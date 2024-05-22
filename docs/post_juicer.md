# What can you do after you run Juicer

There are many more downstream step options for Hi-C data analysis. Juicer internally runs two downstream steps: Arrowhead tool to identify TADs and Hiccups tool to identify loops. A few others are listed below:

* Validate the Hi-C file
* Find compartments 
* Differential loops, etc

I encountered some challenges with working with the Juicer pipeline in regards to its integration with snakemake . 

Juicer is set up such at it updates the Hi-C file over time until the job is done. This makes it hard for the snakemake pipeline to know when the task is complete as there is no way to "flag" this, and snakemake would start the next step before the hi-c file is fully generated.

As a result, the downstream steps have to be called separately for now. As an example, the `Validate Hi-C file` step is available as a bash script in the `scripts` folder.

## How to run validate hi-c step

If not done already, please re-do these steps to ssh into the cluster
```
# ssh into cluster's head node
ssh -Y $USER@biowulf.nih.gov
```

On the bash command prompt you can change the directory to the `scripts` folder and run the script from there. 
* In this example, lets assume the working directory is `/data/CCRCCDI/analysis/ccrtegs9/snakemake_new`
* When calling the script, the parameter to pass is the path to the `aligned` folder which contains the hi-c outputfiles. So in this example, the path would be `/data/CCRCCDI/analysis/ccrtegs9/snakemake_new/results/out_juicer/N/aligned`

```
# change dir to the scripts folder
cd /data/CCRCCDI/analysis/ccrtegs9/snakemake_new/workflow/scripts

#calling script
sbatch postjuicer_01_validate.sh "/data/CCRCCDI/analysis/ccrtegs9/snakemake_new/results/out_juicer/N/aligned"
```
