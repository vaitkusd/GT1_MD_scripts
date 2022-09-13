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

gmx_mpi convert-tpr -s md.tpr -extend 20000 -o md_n.tpr

gmx_mpi mdrun -deffnm md -s md_n.tpr -cpi md.cpt

echo "Production MD complete."

# End
echo "Ending. Job completed"

cd $CWD
exit;
