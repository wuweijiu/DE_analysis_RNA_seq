#!/bin/env bash
#SBATCH --account=xshi72
#SBATCH --job-name=sra2fastq
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=xianglin.shi@emory.edu
#SBATCH --ntasks=1
#SBATCH --partition=month-long-cpu
#SBATCH --cpus-per-task=1
#SBATCH --mem=3gb # mem for each job in the array
#SBATCH --time=1:00:00 # time for each job in the array
#SBATCH --output=parallel_%A_%a.out
#SBATCH --array=0-50

# Settings
# working directory
fastqdump="/home/xshi72/software/sratoolkit/sratoolkit.3.0.0-centos_linux64/bin/fastq-dump"
workDir="/panfs/compbio/users/xshi72/C9Mut/control51/"

pwd
hostname
date --rfc-3339='seconds'
echo "Running program on $SLURM_CPUS_ON_NODE CPU cores"

pushd "${workDir}"
# file wrapper
FILES=(*.sra)


 ${fastqdump} --gzip \
			 --split-3 ${FILES[$SLURM_ARRAY_TASK_ID]}


date --rfc-3339='seconds'