#!/bin/bash
### 
### The account information below need to be changed.
###
### 
### Account information
#PBS -W group_list=dtu_00007 -A dtu_00007
### Job name
#PBS -N XXX
### Specify the number of nodes and thread (ppn) for your job.
#PBS -l nodes=1:gpus=1:ppn=40
### Tell PBS the anticipated run-time for your job, where walltime=HH:MM:SS
#PBS -l walltime=24:00:00
#PBS -l mem=120gb
#PBS -m abe
#################################
### Print date
date

echo Working directory is $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

# Load modules needed by myapplication.x
module load tools  
module load cuda/toolkit/11.5.1
module load gcc
module load gromacs/2021.3-plumed 

# Commands

export OMP_NUM_THREADS=4

bash ./run_md.sh

date
