#########################################################
# IMPORT PYTHON LIBRARIES HERE
#########################################################
import sys
import os
import pandas as pd
import yaml
import pprint
import shutil
import uuid
pp = pprint.PrettyPrinter(indent=4)
#########################################################

#########################################################
# FILE-ACTION FUNCTIONS 
#########################################################
def check_existence(filename):
  if not os.path.exists(filename):
    exit("# File: %s does not exists!"%(filename))

def check_readaccess(filename):
  check_existence(filename)
  if not os.access(filename,os.R_OK):
    exit("# File: %s exists, but cannot be read!"%(filename))

def check_writeaccess(filename):
  check_existence(filename)
  if not os.access(filename,os.W_OK):
    exit("# File: %s exists, but cannot be read!"%(filename))

def get_file_size(filename):
    filename=filename.strip()
    if check_readaccess(filename):
        return os.stat(filename).st_size

#########################################################
# DEFINE CONFIG FILE AND READ IT
#########################################################
CONFIGFILE = str(workflow.overwrite_configfiles[0])
WORKDIR=config["workdir"]

#JUICER_SH=config["juicer_sh"]
#RESTR_SITE_FILE=config["restr_site_file"]
#SITE=config["site"]
#THREADS=config["threads"]
#GENOME=config["genome"]
#STAGEFLAG=config["stageflag"]

# set dir
RESULTSDIR=config["resultsdir"]
if not os.path.exists(join(WORKDIR,"input")):
    os.mkdir(join(WORKDIR,"input"))
if not os.path.exists(RESULTSDIR):
    os.mkdir(RESULTSDIR)

# set method
PROCESS_METHOD=config["process_method"]

#########################################################
# READ TOOLS 
#########################################################
TOOLSYAML = join(WORKDIR,"config/tools.yaml")
check_readaccess(TOOLSYAML)
with open(TOOLSYAML) as f:
    TOOLS = yaml.safe_load(f)

#########################################################
# READ CLUSTER PER-RULE REQUIREMENTS
#########################################################
CLUSTERYAML = join(WORKDIR,"config/cluster.yaml")
check_readaccess(CLUSTERYAML)
with open(CLUSTERYAML) as json_file:
    CLUSTER = yaml.safe_load(json_file)

## Create lambda functions to allow a way to insert read-in values
## as rule directives
getthreads=lambda rname:int(CLUSTER[rname]["threads"]) if rname in CLUSTER and "threads" in CLUSTER[rname] else int(CLUSTER["__default__"]["threads"])
getmemg=lambda rname:CLUSTER[rname]["mem"] if rname in CLUSTER and "mem" in CLUSTER[rname] else CLUSTER["__default__"]["mem"]
getmemG=lambda rname:getmemg(rname).replace("g","G")

#########################################################
# PREPARE REQ DIRS
#########################################################
# get scripts folder
try:
    SCRIPTSDIR = config["scriptsdir"]
except KeyError:
    SCRIPTSDIR = join(WORKDIR,"scripts")
check_existence(SCRIPTSDIR)

# get resources folder
try:
    RESOURCESDIR = config["resourcesdir"]
except KeyError:
    RESOURCESDIR = join(WORKDIR,"resources")
check_existence(RESOURCESDIR)


#########################################################
# READ SAMPLEMANIFEST
#########################################################
# read in manifest
df=pd.read_csv(config["samplemanifest"],sep=",",header=0)

# handle samples
SAMPLES = list(df.sampleName.unique())
SAMPLER1 = dict()
SAMPLER2 = dict()

# handle FASTQ files
for s in SAMPLES:
    # check access to input R1, create symlink to these files in the working dir
    r1=df[df['sampleName']==s].iloc[0].path_to_R1
    check_readaccess(r1)
    r1new=join(WORKDIR,"input",s+".R1.fastq.gz")
    if not os.path.exists(r1new):
        os.symlink(r1,r1new)
    SAMPLER1[s]=r1new
        
    # check access to input R2, create symlink to these files in the working dir
    r2=df[df['sampleName']==s].iloc[0].path_to_R2
    check_readaccess(r2)
    r2new=join(WORKDIR,"input",s+".R2.fastq.gz")
    if not os.path.exists(r2new):
        os.symlink(r2,r2new)
    SAMPLER2[s]=r2new