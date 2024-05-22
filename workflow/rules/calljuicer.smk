rule call_juicer:
    """
    1) Call juicer - run juicer master job once - each job will produce about 100 individual jobs
    this allows control of one sample submission at a time

    ### INPUT
        - all R1 files
        - all R2 files

    ### OUTPUT
        - JUICER files organized by out_juice/sample/
    """
    input:
        R1=join(RESULTSDIR,"out_trim","{sample}_trim.R1.fastq.gz"), 
        R2=join(RESULTSDIR,"out_trim","{sample}_trim.R2.fastq.gz"),
    params:
        trimf=join(RESULTSDIR, "out_trim"),
        base=join(RESULTSDIR,"out_juicer"),
        workdir=config["workdir"],
        juicersh=config["juicer_sh"],
        restrsitefile=config["restr_site_file"],
        site=config["site"],
        threads=config["threads"],
        genome=config["genome"],
        stageflag=config["stageflag"],        
    envmodules:
        TOOLS["juicer"],    
    output:
        hic=join(RESULTSDIR,'out_juicer',"{sample}","aligned/inter.hic"),
        hic30=join(RESULTSDIR,'out_juicer',"{sample}","aligned/inter_30.hic"),
    #threads: 100 #to make sure the job will run one sample at a time
    shell:
        """
        set -exo pipefail
        
        ### function definition
        MAKEDIRS(){{
            if [[ ! -d "$1" ]]; then 
                mkdir -p "$1"
                echo "Dir created: $1"
            else
                echo "Dir already exists: $1"
            fi 
        }}

        # check if juicer folder exists    
        MAKEDIRS {params.base}

        #get sample id

        SAMPLEID={wildcards.sample}
        echo "Extracted value: $SAMPLEID"
       
        #make local variable - all thease are full paths
        SAMPLEF={params.base}"/$SAMPLEID"
        FASTQF={params.base}"/$SAMPLEID/fastq"
        ALIGNEDF="{params.base}/$SAMPLEID/aligned"

        #Make two folders - one with sample id, another #with "fastq"
        MAKEDIRS $SAMPLEF
        MAKEDIRS $FASTQF

        ### Make symlinks. juicer wants underscore and not dot
        fastqR1=$FASTQF"/{wildcards.sample}_trim_R1.fastq.gz"
        fastqR2=$FASTQF"/{wildcards.sample}_trim_R2.fastq.gz"

        # create symlinks. This is required for juicer 
        ln -sf {input.R1} $fastqR1
        ln -sf {input.R2} $fastqR2
        echo "Created symlinks"

        # determine if the results file already exists
        #remove the aligned folder if exist
        if [ -d "$ALIGNEDF" ]; then
            echo "Aligned folder exists. Deleting it"
            rm -rf "$ALIGNEDF"
        else
            echo "Aligned folder does not exist. Juicer can be executed. Continue"
        fi

        # call juicer wrapper
        JUICER_WRAP="{params.workdir}/workflow/scripts/calljuicersample.sh"
        
        #bash 
        bash $JUICER_WRAP $SAMPLEID {params.workdir} {params.juicersh} {params.restrsitefile} {params.site} {params.threads} {params.genome} {params.trimf} {params.stageflag}  

        """