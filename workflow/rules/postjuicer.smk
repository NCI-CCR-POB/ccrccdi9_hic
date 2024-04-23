rule validate:
    """
    Run Validation on hic files

    @Input:
        Hic files
    """
    input:
        hic=join(RESULTSDIR,'out_juicer',"{sample}","aligned/inter.hic"),
        hic30=join(RESULTSDIR,'out_juicer',"{sample}","aligned/inter_30.hic"),
        finclnout=join(RESULTSDIR,'out_juicer',"{sample}","debug/fincln.out"),
    params:
        base=join(RESULTSDIR, 'out_validation'),
    envmodules:
        TOOLS['juicer'],
    output:
        hictxt=join(RESULTSDIR,"out_validation","{sample}.hic_validate.txt"),
        hic30txt=join(RESULTSDIR,"out_validation","{sample}.hic30_validate.txt"),
    shell:
        """
        set -exo pipefail

        echo "Start HiC Validation "

        #create the output folder
        if [ -d {params.base} ]; then
  			echo "out_validation folder exists, continue"
		else
  			mkdir -p {params.base}
  			echo "Make out_validation dir. Continue"
		fi

        SAMPLEID={wildcards.sample}
        echo "Extracted value: $SAMPLEID"

        SAMPLE_TRIM=$SAMPLEID"_trim"
	    echo $SAMPLE_TRIM

        #INPUT_FOLDER=$WORK_DIR$SAMPLETRIM

        juicer_tools validate {input.hic} > {output.hictxt}
	    juicer_tools validate {input.hic30} > {output.hic30txt}

        """

rule normalize:
    """
    Run normalzation
    """
    input:
        hic=join(RESULTSDIR,'out_juicer',"{sample}","aligned/inter.hic"),
        hic30=join(RESULTSDIR,'out_juicer',"{sample}","aligned/inter_30.hic"),
        finclnout=join(RESULTSDIR,'out_juicer',"{sample}","debug/fincln.out"),
    output:
        hicnorm=join(RESULTSDIR,'out_juicer',"{sample}","aligned/","{sample}.norm.inter.hic"),
        hic30norm=join(RESULTSDIR,'out_juicer',"{sample}","aligned/","{sample}.norm.inter30.hic"),
    envmodules:
        TOOLS["juicer"],
    shell:
        """
        echo "Start Normalize hic files"
        set -exo pipefail

        juicer_tools pre addNorm {input.hic} -w 5000 > {output.hicnorm}
        juicer_tools pre addNorm {input.hic30} -w 5000 > {output.hic30norm}

        """

rule arrowhead:
    """
    1) Call arrowhead

    @Input:
        HiC
    """
    input:
        hicnorm=join(RESULTSDIR,'out_juicer',"{sample}","aligned/","{sample}.norm.inter.hic"),
        hic30norm=join(RESULTSDIR,'out_juicer',"{sample}","aligned/","{sample}.norm.inter30.hic"),
        finclnout=join(RESULTSDIR,'out_juicer',"{sample}","debug/fincln.out"),
    params:
        base = join(RESULTSDIR, 'out_arrowhead'),
    envmodules:
        TOOLS['juicer'],
        #TOOLS['CUDA'],
    output:
        contactdomains = join(RESULTSDIR, 'out_arrowhead','contact_domains_list'),
    threads:20
    shell:
        """
        set -exo pipefail

        echo "Start arrowhead"
        
        #create the output folder
        if [ -d {params.base} ]; then
  			echo "Arrowhead output folder exists, continue"
		else
  			mkdir -p {params.base}
  			echo "Make Arrowhead output dir. Continue"
		fi

        # run 
        arrowhead --threads {threads} {input.hic} {output.contactdomains} 

        """

rule hiccups:
    """
    1) Call hiccups

    @Input:
        HiC
    """
    input:
        hicnorm=join(RESULTSDIR,'out_juicer',"{sample}","aligned/","{sample}.norm.inter.hic"),
        hic30norm=join(RESULTSDIR,'out_juicer',"{sample}","aligned/","{sample}.norm.inter30.hic"),
    params:
        base = join(RESULTSDIR, 'out_hiccups'),
    envmodules:
        TOOLS['juicer'],
        #TOOLS['CUDA'],
    output:
        bedpe = join(RESULTSDIR, 'out_hiccups','merged_loops.bedpe'),
    threads:20
    shell:
        """
        set -exo pipefail
        echo "Start Hiccups"

        #create the output folder
        if [ -d {params.base} ]; then
  			echo "Hiccups output folder exists, continue"
		else
  			mkdir -p {params.base}
  			echo "Make Hiccups output dir. Continue"
		fi
        module load CUDA
        # run hiccups on normalized hic files
        juicer_tools hiccups --ignore-sparsity --threads {threads} {input.hic30} {params.base} 

        """




