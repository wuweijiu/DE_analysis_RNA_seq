#!/bin/env bash
#SBATCH --account=xshi72
#SBATCH --job-name=bam2jun
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=xianglin.shi@emory.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20gb # mem for each job in the array
#SBATCH --time=12:00:00 # time for each job in the array
#SBATCH --output=parallel_%A_%a.out
#SBATCH --partition=week-long-cpu
#SBATCH --array=0

workDir="/panfs/compbio/users/xshi72/Sep1/22169_07_05012023/sorted/"

regtools="/home/xshi72/software/regtools/build/regtools"
samtools="/home/xshi72/software/samtools_app/bin/samtools"
pushd "${workDir}"
for bamfile in `ls /panfs/compbio/users/xshi72/Sep1/22169_07_05012023/sorted/*.bam`; do
    echo Converting $bamfile to $bamfile.junc
    ${samtools} index $bamfile
    ${regtools} junctions extract -s 1 -a 8 -m 50 -M 500000 $bamfile -o $bamfile.junc
    echo $bamfile.junc >> test_juncfiles.txt
done


