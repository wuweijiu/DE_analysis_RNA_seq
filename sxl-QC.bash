#!/bin/env bash
#SBATCH --account=xshi72
#SBATCH --job-name=seqQC
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=xianglin.shi@emory.edu
#SBATCH --ntasks=1
#SBATCH --partition=week-long-cpu
#SBATCH --cpus-per-task=3
#SBATCH --mem=1gb # mem for each job in the array
#SBATCH --time=1:00:00 # time for each job in the array
#SBATCH --output=parallel_%A_%a.out
#SBATCH --array=0-101

# max time = 00:53:39
# max mem = 536812K

module purge >/dev/null 2>&1
module add fastqc
# module add python-base python-cbrg fastq_screen

# requirements
# files: raw/*.fastq.gz
# dir: QC/

# Settings
# working directory
workDir="/panfs/compbio/users/xshi72/C9Mut/control51/"
fastqc="/home/xshi72/software/fastqc/FastQC/fastqc"
# number of array = number of raw/*.fastq.gz - 1

pwd
hostname
date --rfc-3339='seconds'
echo "Running program on $SLURM_CPUS_ON_NODE CPU cores"

pushd "${workDir}"

# file wrapper
FILES=(raw/*.fastq.gz)

${fastqc} \
    --outdir QC/ \
    --threads ${SLURM_CPUS_PER_TASK} \
    -- \
    "${FILES[$SLURM_ARRAY_TASK_ID]}"

# for file in raw/*.fastq; do
#     fastq_screen \
#         --conf /t1-data/project/PauklinLab/shared/proj027/analyses/ANALYSIS_SIWEI/fastq_screen_genomes/FastQ_Screen_Genomes/fastq_screen.conf \
#         --outdir QC/ \
#         --threads ${SLURM_CPUS_PER_TASK} \
#         -- \
#         "${file}"
# done

# multiqc \
#     --dirs QC/ \
#     --outdir QC/multiqc/ \
#     --filename multiqc

date --rfc-3339='seconds'
