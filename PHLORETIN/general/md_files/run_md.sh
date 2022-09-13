#!/bin/bash

# Set some environment variables 
CWD=`pwd`
echo "Current directory set to $CWD"
MDP=$CWD/MDP
echo ".mdp files are stored in $MDP"

N=1 #ntmpi MPI threads
M=4 #ntomp OpenMP

# A new directory will be created for each value of lambda and
# at each step in the workflow for maximum organization.

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

sleep 10

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

sleep 10

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

sleep 10

#################
# PRODUCTION MD #
#################
echo "Starting production MD simulation..."

cd ../
mkdir Production_MD
cd Production_MD

gmx_mpi grompp -f $MDP/md.mdp -c ../NPT/npt.gro -p $CWD/topol_complex.top -t ../NPT/npt.cpt -n $CWD/index.ndx -o md.tpr 

gmx_mpi mdrun -deffnm md

echo "Production MD complete."

# End
echo "Ending. Job completed"

cd $CWD
exit;
