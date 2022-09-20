#!/bin/bash

CWD=`pwd`
echo "Current directory set to $CWD"

cd Out
cd Production_MD

# center
gmx_mpi trjconv -s md.tpr -f md.xtc -o md_center.xtc -center -pbc mol -ur compact  << EOF
1
0
EOF

# fit rot and trans
# remove all the solvent trajectories for visuals
gmx_mpi make_ndx -f md.gro -o no_solv.ndx << EOF
1 | 13 | 14
q
EOF
gmx_mpi trjconv -s md.tpr -f md_center.xtc -n no_solv.ndx -o md_fit.xtc -fit rot+trans  << EOF
1
26
EOF
# dump the first frame for visualizations
gmx_mpi trjconv -s md.tpr -n no_solv.ndx -f md_center.xtc -o start.pdb -dump 0 << EOF
26
q
EOF

cd $CWD

#rmsd protein
gmx_mpi rms -s Out/Production_MD/md.tpr -f Out/Production_MD/md_center.xtc -o rmsd.xvg -tu ns  << EOF
4
4
EOF

#rmsd ligand
gmx_mpi rms -s Out/Production_MD/md.tpr -f Out/Production_MD/md_center.xtc -o rmsd_ligand.xvg -tu ns  << EOF
4
14
EOF

exit;
