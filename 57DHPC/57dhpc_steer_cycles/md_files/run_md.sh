#!/bin/bash
# Script to initialize and run the actual simulations
# Main simulation control file. Adjust number of cycles,
# number of steering and releases, etc.
# Set some environment variables 
CWD=`pwd`
echo "Current directory set to $CWD"
MDP=$CWD/MDP
echo ".mdp files are stored in $MDP"

# A new directory will be created at each step in the workflow for maximum organization.

mkdir Out
cd Out

##############################
# ENERGY MINIMIZATION STEEP  #
##############################
echo "Starting minimization" 

mkdir EM
cd EM

# Iterative calls to grompp and mdrun to run the simulations

gmx_mpi grompp -f $MDP/em.mdp -c $CWD/solv_ions.gro -p $CWD/topol_complex.top -o min.tpr

gmx_mpi mdrun -deffnm min

#####################
# NVT EQUILIBRATION #
#####################
echo "Starting constant volume equilibration..."

cd ../
mkdir NVT
cd NVT

gmx_mpi grompp -f $MDP/nvt.mdp -c ../EM/min.gro -r ../EM/min.gro -p $CWD/topol_complex.top -n $CWD/index.ndx -o nvt.tpr

gmx_mpi mdrun -deffnm nvt

echo "Constant volume equilibration complete."

#####################
# NPT EQUILIBRATION #
#####################
echo "Starting constant pressure equilibration..."

cd ../
mkdir NPT
cd NPT

gmx_mpi grompp -f $MDP/npt.mdp -c ../NVT/nvt.gro -r ../NVT/nvt.gro -p $CWD/topol_complex.top -t ../NVT/nvt.cpt -n $CWD/index.ndx -o npt.tpr

gmx_mpi mdrun -deffnm npt

echo "Constant pressure equilibration complete."

#################
# PRODUCTION MD #
#################
# Depends on how many steerings are we doing, will have to modify both this and according MDP files
echo "Starting first simulation cycle..."

cd ../
mkdir Steered_MD
cd Steered_MD

# Steer O5
gmx_mpi grompp -f $MDP/md_pullo1.mdp -c ../NPT/npt.gro -p $CWD/topol_complex.top -t ../NPT/npt.cpt -n $CWD/index.ndx -o md_pullo1.tpr 
gmx_mpi mdrun -deffnm md_pull -s md_pullo1.tpr

# Classic
gmx_mpi grompp -f $MDP/md.mdp -c md_pull.gro -p $CWD/topol_complex.top -t md_pull.cpt -n $CWD/index.ndx -o md.tpr 
gmx_mpi mdrun -deffnm md_pull -s md.tpr -cpi md_pull.cpt -px md_pull_pullx -pf md_pull_pullf

# Steer O7
gmx_mpi grompp -f $MDP/md_pullo2.mdp -c md.gro -p $CWD/topol_complex.top -t md_pull.cpt -n $CWD/index.ndx -o md_pullo2.tpr 
gmx_mpi mdrun -deffnm md_pull -s md_pullo2.tpr -cpi md_pull.cpt -px md_pull_pullx -pf md_pull_pullf

# Classic
gmx_mpi convert-tpr -s md.tpr -until 2000 -o md_n.tpr
gmx_mpi mdrun -deffnm md_pull -s md_n.tpr -cpi md_pull.cpt -px md_pull_pullx -pf md_pull_pullf

echo "First MD cycle complete"


echo "Entering loop mode..."

time=2000
steer_t=100
release_t=900

# original run is cycle 0
# {1..2} will do two more cycles
for cyc in {1..2}
do

# Steer O5
time=$(($time + $steer_t))
gmx_mpi convert-tpr -s md_pullo1.tpr -until $time -o md_pullo1_n.tpr
gmx_mpi mdrun -deffnm md_pull -s md_pullo1_n.tpr -cpi md_pull.cpt -px md_pull_pullx -pf md_pull_pullf

# Release
time=$(($time + $release_t))
gmx_mpi convert-tpr -s md.tpr -until $time -o md_n.tpr
gmx_mpi mdrun -deffnm md_pull -s md_n.tpr -cpi md_pull.cpt -px md_pull_pullx -pf md_pull_pullf

# Steer O7
time=$(($time + $steer_t))
gmx_mpi convert-tpr -s md_pullo2.tpr -until $time -o md_pullo2_n.tpr
gmx_mpi mdrun -deffnm md_pull -s md_pullo2_n.tpr -cpi md_pull.cpt -px md_pull_pullx -pf md_pull_pullf

# Release
time=$(($time + $release_t))
gmx_mpi convert-tpr -s md.tpr -until $time -o md_n.tpr
gmx_mpi mdrun -deffnm md_pull -s md_n.tpr -cpi md_pull.cpt -px md_pull_pullx -pf md_pull_pullf

done

echo "Cycles completed"

# End
echo "Ending. Job completed"

cd $CWD
exit;
