def get_input_fastqs(wildcards):
    d = dict()
    d["R1"] = SAMPLER1[wildcards.sample]
    d["R2"] = SAMPLER2[wildcards.sample]
    return d

rule qc_fastqc:
    """
    1) Runs FastQC report on each sample after adaptors have been removed

    @Input:
        Raw FastQ file (scatter)
    """
    input:
        unpack(get_input_fastqs)
    params:
        base=join(RESULTSDIR, 'out_fastqc'),
    envmodules:
        TOOLS['fastqc'],
    output:
        htmlR1=join(RESULTSDIR,"out_fastqc","{sample}.R1_fastqc.html"),
        htmlR2=join(RESULTSDIR,"out_fastqc","{sample}.R2_fastqc.html"),
    shell:
        """
        set -exo pipefail
        if [[ -d "/lscratch/$SLURM_JOB_ID" ]]; then 
            TMPDIR="/lscratch/$SLURM_JOB_ID"
        else
            dirname=$(basename $(mktemp))
            TMPDIR="/dev/shm/$dirname"
            mkdir -p $TMPDIR
        fi

        #create the output folder
        if [ -d {params.base} ]; then
  			echo "Fastqc folder exists, continue"
		else
  			mkdir -p {params.base}
  			echo "Make Fastqc dir. Continue"
		fi

        # run FASTQC
        fastqc {input.R1} {input.R2} -t 6 -o {params.base}
        """

rule trim:
    """
    Remove adapters using cutadapt:
    * min read length is 35
    * min avg. sliding window quality score of 10 per 10 bp window is required
    * trim 10 bases from 5' end and 0 bases from 3' end
    """
    input:
        unpack(get_input_fastqs)
        #R1 = join(WORKDIR,"input","{sample}.R1.fastq.gz"),
        #R2 = join(WORKDIR,"input","{sample}.R2.fastq.gz"),
    output:
        R1=join(RESULTSDIR,"out_trim","{sample}_trim.R1.fastq.gz"),
        R2=join(RESULTSDIR,"out_trim","{sample}_trim.R2.fastq.gz"),
    params:
        adapters=config["adapters"],
        base=join(RESULTSDIR, 'out_trim'),
    threads: 
        getthreads("trim"),
    envmodules:
        TOOLS["cutadapt"],
    shell:
        """
        echo "Trim-start"
        set -exo pipefail
        if [[ -d "/lscratch/$SLURM_JOB_ID" ]]; then 
            TMPDIR="/lscratch/$SLURM_JOB_ID"
        else
            dirname=$(basename $(mktemp))
            TMPDIR="/dev/shm/$dirname"
            mkdir -p $TMPDIR
        fi

        #create the output folder
        if [ -d {params.base} ]; then
  			echo "Trim folder exists, continue"
		else
  			mkdir -p {params.base}
  			echo "Make Trim dir. Continue"
		fi

        cutadapt \\
        --pair-filter=any \\
        -q 10,0 \\
        -a file:{params.adapters} \\
        --minimum-length 35 \\
        -j {threads} \\
        -o {output.R1} \\
        -p {output.R2} \\
        {input.R1} {input.R2}

        echo "Trim-end"

        """

rule qc_fastqc_trim:
    """
    1) Runs FastQC report on each sample after adaptors have been removed

    @Input:
        Raw FastQ file (scatter)
    """
    input:
        R1 = rules.trim.output.R1,
        R2 = rules.trim.output.R2
    params:
        base = join(RESULTSDIR, 'out_fastqc'),
    envmodules:
        TOOLS['fastqc'],
    output:
        htmlR1 = join(RESULTSDIR, 'out_fastqc','{sample}_trim.R1_fastqc.html'),
        htmlR2 = join(RESULTSDIR, 'out_fastqc','{sample}_trim.R2_fastqc.html'),
    shell:
        """
        set -exo pipefail
        if [[ -d "/lscratch/$SLURM_JOB_ID" ]]; then 
            TMPDIR="/lscratch/$SLURM_JOB_ID"
        else
            dirname=$(basename $(mktemp))
            TMPDIR="/dev/shm/$dirname"
            mkdir -p $TMPDIR
        fi

        #create the output folder
        if [ -d {params.base} ]; then
  			echo "Fastqc folder exists, continue"
		else
  			mkdir -p {params.base}
  			echo "Make Fastqc dir. Continue"
		fi

        # run FASTQC
        fastqc {input.R1} {input.R2} -t 6 -o {params.base}
        """

rule multiqc:
    """
    merges FastQC reports for pre/post trimmed fastq files into MultiQC report
    https://multiqc.info/docs/#running-multiqc
    """
    input:
        fqR1=expand(rules.qc_fastqc.output.htmlR1,sample=SAMPLES),
        fqR2=expand(rules.qc_fastqc.output.htmlR2,sample=SAMPLES),
        fqtrimR1=expand(rules.qc_fastqc_trim.output.htmlR1,sample=SAMPLES),
        fqtrimR2=expand(rules.qc_fastqc_trim.output.htmlR2,sample=SAMPLES)
    params:
        qc_config = join(WORKDIR,'config','multiqc_config.yaml'),
        dir_fqc = join(RESULTSDIR, 'out_fastqc'),
        dir_mulq = join(RESULTSDIR, 'out_multiqc'),
    envmodules:
        TOOLS['multiqc'],
    output:
        report = join(RESULTSDIR,'out_multiqc','multiqc_report.html')
    shell:
        """
        echo "MultiQC Start"
        set -exo pipefail

        if [[ -d "/lscratch/$SLURM_JOB_ID" ]]; then 
            TMPDIR="/lscratch/$SLURM_JOB_ID"
        else
            dirname=$(basename $(mktemp))
            TMPDIR="/dev/shm/$dirname"
            mkdir -p $TMPDIR
        fi

        dir1="{params.dir_mulq}/multiqc_data"
        # Check if the directory is empty
        if [ "$(ls -A "$dir1")" ]; then
            echo "Dir is not empty. Clearing it"
            
            # Remove all files and dir within it
            rm -r "$dir1"/*
            echo "Dir is cleared."
        else
            echo "Dir is already empty."
        fi

        #multiqc -f -v \\
        #    -c {params.qc_config} \\
        #    -d -dd 1 \\
        #    {params.dir_fqc} \\
        #   -o $TMPDIR/qc

        multiqc {params.dir_fqc} -o $TMPDIR/qc 
        
        mv $TMPDIR/qc/multiqc_report.html {output.report}
        mv $TMPDIR/qc/* {params.dir_mulq}

        echo "MultiQC End"
        """