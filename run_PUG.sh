#!/bin/bash
#SBATCH --job-name=PUG
#SBATCH --partition=batch
#SBATCH --mail-type=END,FAIL
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4gb
#SBATCH --time=5:00:00 
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.err

#create output directory
OUTDIR="/scratch/eab77806/jim_projects/ranunculales/"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

# load required modules
ml BioPerl/1.7.2-GCCcore-8.3.0

# run PUG
perl $HOME/PUG/PUG.pl --trees gene_trees --outgroup Genome_Vitis --species_tree Ranunculales_Species_tree.tre --debug

# make environment for R script
ml purge
ml R

# run R script to generate figure
Rscript ~/PUG/PUG_Figure_Maker.R PUG_Labeled_Species_Tree.tre PUG_SUMMARIZED_5080.txt figure.pdf