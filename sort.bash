#!/bin/env bash
#SBATCH --account=xshi72
#SBATCH --job-name=sort
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=week-long-cpu
#SBATCH --mail-user=xianglin.shi@emory.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --mem=6gb # mem for each job in the array
#SBATCH --time=2:00:00 # time for each job in the array
#SBATCH --output=parallel_%A.out
#SBATCH --array=0



## NOTES
# we do not specify the number of node to use
#   so it will be determined automaticaly
# output filename: %A means slurm job ID and %a means array index
# fields to modify:
#   job name
#   number of tasks (number of array ids)
#   cpus, memory time

# max time = 01:13:14
# max mem = 2924772K

# requirements
# required files: mapping/*_rep_?.bam
# required dir: counting/

# Settings
# working directory
samtools="/home/xshi72/software/samtools_app/bin/samtools"
workDir="/panfs/compbio/users/xshi72/C9Mut/control51/mapping/"
gtf="/panfs/compbio/users/xshi72/Patients_14/ref_genome//gencode.v40.primary_assembly.annotation.gtf"
FILES=(*.bam)
pwd
hostname
date --rfc-3339='seconds'
echo "Running program on $SLURM_CPUS_ON_NODE CPU cores"

pushd "${workDir}"

# running
for bamfile in `ls *.bam`; do
     ${samtools} sort $bamfile -o sort/$bamfile
    
done
    
popd

date --rfc-3339='seconds'
