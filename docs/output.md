# Expected Outputs
The following directories are created under the WORKDIR/results directory:

* `out_fastqc`: This folder will contain the output of the execution of the tool FASTQC  on the raw fastq and trimmed fastq files  
* `out_trim`: This folder will contain the trimmed fastq files
* `out_multiqc`: This folder will contain a MultiQC HTML report file which summarizes the statistics obtained by the FASTQC tool
* `out_juicer`: This has  a sub-folder for each sample, and within that are  the results of the juicer run with the following sub-folders
    - `aligned`: This the main folder with all the results.  The `hic` files and the `merged_nodups.txt` are inside this folder
    - `debug`: Log files
    - `fastq`: intermediate files
    - `splits`: intermediate files
  
<img width="249" alt="Screenshot 2024-04-24 at 2 39 17 PM" src="https://github.com/NCI-CCR-POB/ccrccdi9_hic/assets/1800604/33669c13-88f6-4f71-a047-771f5563bcaa">

## Notes
* Users will be able to load the two `hic` files and the two `inter_hists.m` files to Juicebox to view the results
* The `merged_nodups.txt` is needed for further secondary analysis by some tools

## More details about individual ouputs from Juicer
Reference: https://github.com/aidenlab/juicer/wiki/Running-Juicer-on-a-cluster
* inter.hic / inter_30.hic: The .hic files for Hi-C contacts at MAPQ > 0 and at MAPQ >= 30, respectively
* merged_nodups.txt: The Hi-C contacts with duplicates removed. This file is also input to the assembly and diploid pipelines
* collisions.txt: Reads that map to more than two places in the genome
* inter.txt, inter_hists.m / inter_30.txt, inter_30_hists.m: The statistics and graphs files for Hi-C contacts at MAPQ > 0 and at MAPQ >= 30, respectively. These are also stored within the respective .hic files in the header. The .m files can be loaded into Matlab. The statistics and graphs are displayed under Dataset Metrics when loaded into Juicebox
* dups.txt, opt_dups.txt: Duplicates and optical duplicates
* abnormal.sam, unmapped.sam: Abnormal chimeric and unmapped reads
* merged_sort.txt: This is a combination of merged_nodups / dups / opt_dups and can be deleted once the pipeline has successfully completed
* stats_dups.txt / stats_dups_hists.m: Statistics and graphs on the duplicates
