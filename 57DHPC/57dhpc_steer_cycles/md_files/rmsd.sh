#!/bin/bash

### This very much depends on the number of simulations
### modify carefully
CWD=`pwd`
echo "Current directory set to $CWD"

cd Out
cd Steered_MD

# remove all the solvent trajectories for visuals
# make sure that file name exists
gmx_mpi make_ndx -f md_pullo1.gro -o no_solv.ndx << EOF
1 | 13 | 14
q
EOF

cd $CWD

### modify run names ###
for run in o1 o2
do

cd Out
cd Steered_MD
# center
gmx_mpi trjconv -s md_pull${run}.tpr -f md_pull${run}.xtc -o md_center${run}.xtc -center -pbc mol -ur compact  << EOF
1
0
EOF

# fit rot and trans
EOF
gmx_mpi trjconv -s md_pull${run}.tpr -f md_center${run}.xtc -n no_solv.ndx -o md_fit${run}.xtc -fit rot+trans  << EOF
1
26
EOF
# dump the first frame for visualizations
gmx_mpi trjconv -s md_pull${run}.tpr -n no_solv.ndx -f md_center${run}.xtc -o start.pdb -dump 1 << EOF
26
q
EOF

cd $CWD

#rmsd protein
gmx_mpi rms -s Out/Steered_MD/md_pull${run}.tpr -f Out/Steered_MD/md_center${run}.xtc -o rmsd${run}.xvg -tu ns  << EOF
4
4
EOF

#rmsd ligand
gmx_mpi rms -s Out/Steered_MD/md_pull${run}.tpr -f Out/Steered_MD/md_center${run}.xtc -o rmsd_ligand${run}.xvg -tu ns  << EOF
4
14
EOF

done
