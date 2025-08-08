#!/bin/bash
#SBATCH --job-name=fa_to_trees
#SBATCH --partition=batch
#SBATCH --mail-type=END,FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=30gb
#SBATCH --time=4:00:00
#SBATCH --array=1-5000
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.err

gene=$(awk "NR==${SLURM_ARRAY_TASK_ID}" genelist.txt)

#create output directory
OUTDIR="/scratch/eab77806/jim_projects/ranunculales/"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

# run mafft 
ml MAFFT/7.526-GCC-13.3.0-with-extensions
mafft --thread $SLURM_CPUS_PER_TASK --auto fastas4jim_SynHOGs/$gene.fa > alignments/$gene.aln

# make iqtree directory and run iqtree
if [ ! -d iqtree ]
then
    mkdir -p iqtree
fi
cd iqtree

ml purge
ml IQ-TREE/2.3.6-gompi-2023a
iqtree2 -s ../alignments/$gene.aln -nt AUTO -bb 1000 -m MFP --prefix $gene --redo-tree
