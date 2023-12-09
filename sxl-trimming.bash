#!/bin/env bash
#SBATCH --account=xshi72
#SBATCH --job-name=fastpTrimDefaultPE
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=xianglin.shi@emory.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --mem=10gb # mem for each job in the array
#SBATCH --time=2:00:00 # time for each job in the array
#SBATCH --output=parallel_%A_%a.out
#SBATCH --partition=week-long-cpu
#SBATCH --array=0-101

## NOTES
# This script use default trimming with fastp
# max time = 00:40:07
# max mem = 7619500K

## NOTES
# we do not specify the number of node to use
#   so it will be determined automaticaly
# output filename: %A means slurm job ID and %a means array index
# fields to modify:
#   job name
#   number of tasks (number of array ids)
#   cpus, memory time
# Cores: "${SLURM_CPUS_PER_TASK}"
# Processing file: "${FILES[$SLURM_ARRAY_TASK_ID]}"

# requirements
# required files: *_R1.fastq.gz *_R2.fastq.gz
# required dir: trimmed/

# Settings
# working directory
fastp="/home/xshi72/software/fastp/fastp" # The folder location of FASTP 
workDir="/panfs/compbio/users/xshi72/C9Mut/control51/raw"
#The location of your Raw file need to be timmed.
# number of array = number of *_R1.fastq.gz - 1

module purge >/dev/null 2>&1

pushd "${workDir}"
pwd
hostname
date --rfc-3339='seconds'
echo "Running program on $SLURM_CPUS_ON_NODE CPU cores"

# file wrapper
FILES=(*_R1.fastq.gz)

# running
${fastp} \
  --in1 ${FILES[$SLURM_ARRAY_TASK_ID]} \
  --in2 ${FILES[$SLURM_ARRAY_TASK_ID]/_R1.fastq.gz/_R2.fastq.gz} \
  --out1 trimmed/${FILES[$SLURM_ARRAY_TASK_ID]/_R1.fastq.gz/_R1_trimmed.fastq.gz} \
  --out2 trimmed/${FILES[$SLURM_ARRAY_TASK_ID]/_R1.fastq.gz/_R2_trimmed.fastq.gz} \
  --html trimmed/${FILES[$SLURM_ARRAY_TASK_ID]/_R1.fastq.gz/.html} \
  --thread ${SLURM_CPUS_PER_TASK} \
  --trim_poly_g

popd

date --rfc-3339='seconds'
