# Preparing Files
The pipeline is controlled through editing configuration and manifest files. Defaults are found in the /WORKDIR/config and /WORKDIR/manifest directories, after initialization.

## Configs
The configuration files control parameters and software of the pipeline. These files are listed below. To run this pipeline only the following files need to be changed

- config/config.yaml
- resources/cluster.yaml 

### Cluster Config
The cluster configuration file dictates the resouces to be used during submission to Biowulf HPC. This file *need not be edited* if using the Biowulf HPC. Editing this file is only needed for use in another HPC

### Config YAML
There are several groups of parameters that are editable for the user to control the various aspects of the pipeline. These are :

- Working directory: The directory where the snakemake project exists. For example `<path>/snakemake_test`
- Results directory: The directory where all the results will be. Typically will be in the `results` directory within the snakemake project
- Scripts directory: Location of the "scripts" directory. This will typically be in `workflow/scripts` within the snakemake project
- Sample manifest: Names and paths to the input files. This will typically be in `manifest/sample_manifest.csv` within the snakemake project
- Adapter: Path to a fasta file that contains the adapter sequences. This file has been provided to you at this location `resources` within the snakemake project
- The following are settings for the Juicer tool to run
    - Genome: default to `hg38`. Currently support is only provided for this genome
    - Link to the juicer script. Located inside `resources` within the snakemake project
    - Restriction file site: Provided to you inside `resources` within the snakemake project. The test data is for Arima. More restriction site options can be found at `/usr/local/apps/juicer/juicer-1.6/restriction_sites`
    - Threads: Set to 54
    - Stageflag: Offers users a way to control the running of Juicer . Can accept the following values `merge" | "dedup" | "final" | "postproc" | "early" | "chimeric" `. Default value is `NA` which is the normal running mode. For more details on these settings please read the Juicer wiki page.

Figure shows restriction site file options avaiable as of May 2024 in Biowulf
<img width="878" alt="Screenshot 2024-05-08 at 2 41 37 PM" src="https://github.com/NCI-CCR-POB/fruitsc/assets/1800604/9affe61c-9d5f-49b8-bb88-2a792f1720fa">


## Preparing Manifest (REQUIRED)
There is one manifest that is required for this pipeline.The paths of this file is defined in the snakemake_config.yaml file. This file is `samplemanifest`.

This manifest will include information to sample level information. It includes the following column headers:

- sampleName: the sample name WITHOUT replicate number (IE "SAMPLE")
- path_to_R1: the full path to R1 fastq file (IE "/path/to/sample1.R1.fastq")
- path_to_R2: the full path to R1 fastq file (IE "/path/to/sample2.R2.fastq")

An example sampleManifest file is shown below:


| sampleName| path_to_R1| path_to_R2
| --- |--- |--- |--- |--- |--- |--- |
| S1| PIPELINE_HOME/input/S1.R1.fastq.gz| PIPELINE_HOME/input/S1.R2.fastq.gz
| S2| PIPELINE_HOME/input/S2.R1.fastq.gz| PIPELINE_HOME/input/S2.R2.fastq.gz

## Merge technical replicates
Note: Prior to using this pipeline, please merge any technical replicates - these could be files that were run across multiple lanes, or files that were generated from the same library i.e. same growth. Example code has been provided below:

Examples:
`cat S1/*R1*fastq.gz > S1/S1.R1.fastq.gz`
`cat S1/*R2*fastq.gz > S1/S1.R2.fastq.gz`

The input fastq files to this pipeline are located in the `input` folder. Currently the `input` folder contains sample test data.
