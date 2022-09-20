#!/bin/bash

# Set some environment variables 
CWD=`pwd`
echo "Current directory set to $CWD"
MDP=$CWD/MDP
echo ".mdp files are stored in $MDP"

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

sleep 5

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

sleep 5

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

sleep 5

#################
# steered MD #
#################
# Depends on how many steerings are we doing, will have to modify both this and according MDP files
echo "Starting steered MD simulation..."

cd ../
mkdir Steered_MD
cd Steered_MD

gmx_mpi grompp -f $MDP/md_pullo1.mdp -c ../NPT/npt.gro -p $CWD/topol_complex.top -t ../NPT/npt.cpt -n $CWD/index.ndx -o md_pullo1.tpr 

gmx_mpi mdrun -deffnm md_pullo1

gmx_mpi grompp -f $MDP/md_pullo2.mdp -c ../NPT/npt.gro -p $CWD/topol_complex.top -t ../NPT/npt.cpt -n $CWD/index.ndx -o md_pullo2.tpr 

gmx_mpi mdrun -deffnm md_pullo2

echo "steered MD complete."

sleep 5

#################
# PRODUCTION MD #
#################
echo "Continuing with classic production MD"

#cd ../
#mkdir Production_MD
#cd Production_MD

gmx_mpi grompp -f $MDP/md.mdp -c md_pullo1.gro -p $CWD/topol_complex.top -t md_pullo1.cpt -n $CWD/index.ndx -o mdo1.tpr 

gmx_mpi mdrun -deffnm md_pullo1 -s mdo1.tpr -cpi md_pullo1.cpt -px md_pullo1_pullx -pf md_pullo1_pullf

gmx_mpi grompp -f $MDP/md.mdp -c md_pullo2.gro -p $CWD/topol_complex.top -t md_pullo2.cpt -n $CWD/index.ndx -o mdo2.tpr 

gmx_mpi mdrun -deffnm md_pullo2 -s mdo2.tpr -cpi md_pullo2.cpt -px md_pullo2_pullx -pf md_pullo2_pullf

echo "Production MD complete."

# End
echo "Ending. Job completed"

cd $CWD
exit;
