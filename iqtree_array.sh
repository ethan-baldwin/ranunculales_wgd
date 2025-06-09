#!/bin/bash
#SBATCH --job-name=iqtree
#SBATCH --partition=batch
#SBATCH --mail-type=END,FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4gb
#SBATCH --time=12:00:00
#SBATCH --array=1-2000 
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.err

gene=$(awk "NR==${SLURM_ARRAY_TASK_ID}" genelist.txt)

#create output directory
OUTDIR="/scratch/eab77806/jim_projects/ranunculales/iqtree"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

ml IQ-TREE/2.2.2.6-gompi-2022a
iqtree2 -s ../alignments/$gene.fa -nt AUTO -bb 1000 -m MFP --prefix $gene --redo-tree
