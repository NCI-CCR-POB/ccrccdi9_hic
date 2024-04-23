# Expected Outputs
The following directories are created under the WORKDIR/results directory:

* `out_fastqc`: This folder will contain the output of the execution of the tool FASTQC  on the raw fastq and trimmed fastq files  
* `out_trim`: This folder will contain the trimmed fastq files
* `out_multiqc`: This folder will contain a MultiQC HTML report file which summarizes the statistics obtained by the FASTQC tool
* `out_juicer`: This has  a sub-folder for each sample, and within that are  the results of the juicer run with the following sub-folders
    - `aligned`: This the main folder with all the results.  The `hic` files and the `merged_nodups.txt` are inside this folder
    - `debug`
    - `fastq`
    - `splits`

## Notes
* Users will be able to load the two `hic` files and the two `inter_hists.m` files to Juicebox to view the results
* The `merged_nodups.txt` is needed for further secondary analysis by some tools
