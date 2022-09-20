#!/bin/bash

# Set some environment variables 
CWD=`pwd`
echo "Current directory set to $CWD"
MDP=$CWD/MDP
echo ".mdp files are stored in $MDP"

N=1 #ntmpi MPI threads
M=4 #ntomp OpenMP


#################
# PRODUCTION MD #
#################
echo "Starting production MD simulation..."

cd Out/Production_MD

gmx_mpi grompp -f $MDP/md.mdp -c md_pullo1.gro -p $CWD/topol_complex.top -t md_pullo1.cpt -n $CWD/index.ndx -o mdo1.tpr 

gmx_mpi mdrun -deffnm md_pullo1 -s mdo1.tpr -cpi md_pullo1.cpt -px md_pullo1_pullx -pf md_pullo1_pullf

gmx_mpi grompp -f $MDP/md.mdp -c md_pullo2.gro -p $CWD/topol_complex.top -t md_pullo2.cpt -n $CWD/index.ndx -o mdo2.tpr 

gmx_mpi mdrun -deffnm md_pullo2 -s mdo2.tpr -cpi md_pullo2.cpt -px md_pullo2_pullx -pf md_pullo2_pullf

echo "Production MD complete."

# End
echo "Ending. Job completed"

cd $CWD
exit;
