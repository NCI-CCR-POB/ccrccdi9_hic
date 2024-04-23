#!/bin/bash

echo "Sampleid: $1"
echo "Current Workdir: $2"
echo "Juicer.sh location: $3"
echo "Restr Site file: $4"
echo "Site: $5"
echo "Threads: $6"
echo "Genome: $7"
echo "Location of trimmed fastq files: $8"
echo "StageFlag: $9"

SAMPLE=$1
WORK_DIR=$2
JUICER_SH=$3
RESTR_SITE_FILE=$4
SITE=$5
THREADS=$6
GENOME=$7
TRIM_F=$8
STAGEFLAG=$9

SAMPLETRIM=$SAMPLE"_trim"
echo $SAMPLETRIM

### Settings 
MAIN_FOLDER=$WORK_DIR"/results/out_juicer/"$SAMPLE
echo "Main folder: $MAIN_FOLDER"

##### Stage information to run juicer. Default value is NA. Other values are 
#More details on stage here: https://github.com/aidenlab/juicer/wiki/Usage
#-Use "merge" when alignment has finished but the merged_sort file has notyet been created.
#Use "dedup" when the files have been merged into merged_sort butmerged_nodups has not yet been created.
#Use "final" when the reads have been deduped into merged_nodups but thefinal stats and hic files have not yet been created.
#Use "postproc" when the hic files have been created and onlypostprocessing feature annotation remains to be completed.
#Use "early" for an early exit, before the final creation of the hic files Can also use -e flag to exit early

#Make two folders - one with sample id, another with "fastq"
#if [ ! -d "$MAIN_FOLDER" ]; then
#    mkdir -p "$MAIN_FOLDER"
#	mkdir -p "$MAIN_FOLDER/fastq"
#	echo "Folder created"
#elif [ ! -d "$MAIN_FOLDER/fastq" ]; then
#	mkdir -p "$MAIN_FOLDER/fastq"  
#	echo "Created Fastq folder"
#else 
#	echo "Folder already exists"
#fi 

#echo "created folders"




###create symlinks

#ln -s $TRIM_F"/$SAMPLETRIM.R1.fastq.gz" $MAIN_FOLDER"/fastq/"$SAMPLETRIM"_R1.fastq.gz"
#ln -s $TRIM_F"/$SAMPLETRIM.R2.fastq.gz" $MAIN_FOLDER"/fastq/"$SAMPLETRIM"_R2.fastq.gz"
#echo "created symlinks"

# determine if the results file already exists
#remove the aligned folder if exist
ALIGNEDF="$MAIN_FOLDER/aligned"
if [ -d "$ALIGNEDF" ]; then
  	echo "Aligned folder exists. Deleting it"
    rm -rf $ALIGNEDF
else
  	echo "Aligned folder does not exist. Juicer can be executed. Continue"
fi

JOBNAME="Juicer_$SAMPLE"
echo $JOBNAME
#!/bin/bash
#SBATCH --partition=norm
#SBATCH --job-name=$JOBNAME
#SBATCH --constraint="x2695|x2680"
#SBATCH --time=72:00:00
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=16
echo "Load juicer module and run command"
module load juicer

#Default running script is with the STAGEFLAG="NA". 

case "$STAGEFLAG" in
    "NA")
        echo "STAGEFLAG is NA"
        # Perform actions when STAGEFLAG is "NA"
        $JUICER_SH -g $GENOME -d $MAIN_FOLDER -s $SITE -y $RESTR_SITE_FILE -t $THREADS -f
        ;;
    "merge" | "dedup" | "final" | "postproc" | "early" | "chimeric")
        echo "STAGEFLAG is one of the accepted values (merge, dedup, final, postproc, early, chimeric)."
        echo $STAGEFLAG
        # Perform actions when STAGEFLAG is one of the accepted values
        $JUICER_SH -g $GENOME -d $MAIN_FOLDER -s $SITE -y $RESTR_SITE_FILE -t $THREADS -f -S $STAGEFLAG
        ;;
    *)
        echo "Error: STAGEFLAG is not valid. It must be NA or one of the accepted values (merge, dedup, final, postproc, early, chimeric)."
        # Print error message for invalid STAGEFLAG
        ;;
esac

