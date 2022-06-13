#!/bin/bash

## conda env with acpype installed
## can be omitted, if the default python env has all required packages
conda activate default



# create receptor gro
gmx pdb2gmx -f receptor.pdb -o receptor.gro -ff amber14sb -water tip3p -ignh

# generate phl topology
acpype -i phl.pdb -b PHL -o gmx
# fetch generated files
mv PHL.acpype/PHL_GMX.gro ./phl.gro
mv PHL.acpype/PHL_GMX.itp ./phlx.itp
# clean phloretin topology files
python fix_phl_top.py

# create complex
python create_complex.py

#update topology file
python prepare_top.py

#solvate
gmx editconf -f complex.gro -o newbox.gro -bt cubic -d 1.0
gmx solvate -cp newbox.gro -cs spc216.gro -p topol_complex.top -o solv.gro

# get tpr file
gmx grompp -f $MDP/ions.mdp -c solv.gro -p topol_complex.top -o ions.tpr

#add ions
gmx genion -s ions.tpr -o solv_ions.gro -p topol_complex.top -pname NA -nname CL -neutral << EOF
SOL
EOF

# restrain ligand
gmx make_ndx -f phl.gro -o index_phl.ndx << EOF
0 & ! a H*
q
EOF
gmx genrestr -f phl.gro -n index_phl.ndx -o posre_phl.itp -fc 1000 1000 1000 << EOF
System_&_!H*
EOF

# restrain ligand
gmx make_ndx -f upg.gro -o index_upg.ndx << EOF
0 & ! a H*
q
EOF
gmx genrestr -f upg.gro -n index_upg.ndx -o posre_upg.itp -fc 1000 1000 1000 << EOF
System_&_!H*
EOF

#set up protein ligand group
gmx make_ndx -f solv_ions.gro -o index.ndx << EOF
1 | 13 | 14
q
EOF
