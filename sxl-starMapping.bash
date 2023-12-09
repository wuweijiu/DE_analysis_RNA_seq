#!/bin/env bash
#SBATCH --account=xshi72
#SBATCH --job-name=star
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=xianglin.shi@emory.edu
#SBATCH --ntasks=1
#SBATCH --partition=week-long-cpu
#SBATCH --cpus-per-task=3
#SBATCH --mem=32gb # mem for each job in the array
#SBATCH --time=12:00:00 # time for each job in the array
#SBATCH --output=parallel_%A_%a.out
#SBATCH --array=0-17

# NOTE this can only be used in RNA-seq analysis
# reference: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4631051/
# reference: https://pubmed.ncbi.nlm.nih.gov/27115637/

# max mem = 33953068K

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
# Files: raw/*_R1.fastq.gz and raw/*_R2.fastq.gz
# Dir: mapping/

# Settings
# working directory
workDir="/panfs/compbio/users/xshi72/C9Mut/sample18/"
genome="/panfs/compbio/users/xshi72/Patients_14/ref_genome"
samtools="/home/xshi72/software/samtools_app/bin/samtools"
# genome="/t1-data/project/PauklinLab/shared/proj027/analyses/ANALYSIS_SIWEI/Ensembl/GRCm39.106"
gtf="/panfs/compbio/users/xshi72/Patients_14/ref_genome//gencode.v40.primary_assembly.annotation.gtf"
# gtf="/t1-data/project/PauklinLab/shared/proj027/analyses/ANALYSIS_SIWEI/Ensembl/GRCm39.106/Mus_musculus.GRCm39.106.gtf"
# number of array = number of raw/*_R1.fastq.gz - 1
STAR="/home/xshi72/software/STAR-2.7.10a/bin/Linux_x86_64_static/STAR"


module purge >/dev/null 2>&1
module add STAR samtools pigz
set -x -e -u -o pipefail

pwd
hostname
date --rfc-3339='seconds'
echo "Running program on $SLURM_CPUS_ON_NODE CPU cores"

pushd "${workDir}"

# file wrapper
FILES=(raw/*_R1_trimmed.fastq.gz)

outputFile=${FILES[$SLURM_ARRAY_TASK_ID]/_R1_trimmed.fastq.gz/}
outputFile=${outputFile/raw\//}
sortfile=${FILES[$SLURM_ARRAY_TASK_ID]/_sort.bam/}
# running
# indexing STAR --runThreadN 6 --runMode genomeGenerate ./ --genomeFastaFiles GRCh38.primary_assembly.genome.fa --sjdbGTFfile gencode.v43.annotation.gtf --sjdbOverhang 99
${STAR} --runThreadN ${SLURM_CPUS_PER_TASK} \
--genomeDir ${genome} \
--twopassMode Basic \
--sjdbGTFfile ${gtf} \
--readFilesIn ${FILES[$SLURM_ARRAY_TASK_ID]} ${FILES[$SLURM_ARRAY_TASK_ID]/_R1_trimmed.fastq.gz/_R2_trimmed.fastq.gz} \
--readFilesCommand zcat \
--outSAMtype BAM Unsorted \
--outFileNamePrefix mapping/${outputFile} 

mv mapping/${outputFile}Aligned.out.bam mapping/${outputFile}.bam

rm -rf mapping/${outputFile}.Log.progress.out mapping/${outputFile}._STARgenome mapping/${outputFile}._STARpass1

# other parameters: outReadsUnmapped

# get unmapped reads
# samtools fasta -f 4 mapping/${outputFile}.bam >mapping/${outputFile}_unmapped.fasta
# pigz --processes ${SLURM_CPUS_PER_TASK} mapping/${outputFile}_unmapped.fasta

# get flagstats
# samtools flagstat --threads ${SLURM_CPUS_PER_TASK} mapping/${outputFile}.bam >mapping/${outputFile}_flagstat.txt

popd

date --rfc-3339='seconds'
