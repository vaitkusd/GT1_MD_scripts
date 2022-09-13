#!/bin/bash

LIG='HPC'
lig='hpc'


## conda env with acpype installed
## can be omitted, if the default python env has all required packages
#conda activate default

# Set some environment variables 
CWD=`pwd`
echo "Current directory set to $CWD"
MDP=$CWD/MDP
echo ".mdp files are stored in $MDP"

# create receptor gro
gmx pdb2gmx -f receptor.pdb -o receptor.gro -ff amber14sb -water tip3p -ignh

# generate phl topology
acpype -i $lig.pdb -b ${LIG} -o gmx
# fetch generated files
mv ${LIG}.acpype/${LIG}_GMX.gro ./${lig}.gro
mv ${LIG}.acpype/${LIG}_GMX.itp ./${lig}x.itp
# clean phloretin topology files
python fix_lig_top.py $lig

# create complex
python create_complex.py $lig

#update topology file
python prepare_top.py $lig

#solvate
gmx editconf -f complex.gro -o newbox.gro -bt cubic -d 1.0
gmx solvate -cp newbox.gro -cs spc216.gro -p topol_complex.top -o solv.gro

# get tpr file
gmx grompp -f $MDP/ions.mdp -c solv.gro -p topol_complex.top -o ions.tpr

#add ions
gmx genion -s ions.tpr -o solv_ions.gro -p topol_complex.top -np 1 -pname NA -nn 1 -nname CL -neutral << EOF
SOL
EOF

# restrain ligand
gmx make_ndx -f $lig.gro -o index_$lig.ndx << EOF
0 & ! a H*
q
EOF
gmx genrestr -f $lig.gro -n index_$lig.ndx -o posre_$lig.itp -fc 1000 1000 1000 << EOF
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

# get the right acceptor atoms for steering
# change '1' to anything else if there's no symmetry in ligand (aka just extract all specified atom names)
atoms=$(python extract_steer_atoms.py 0)
echo "selected atoms"
echo "$atoms"

# count the number of index groups currently present
selection_lim=$(expr $(cat upg.gro | grep UPG | wc -l) + $(cat $lig.gro | grep ZIN | wc -l) + 24)
his=`grep -w $(pwd | rev | cut -d "/" -f 1 | rev) ../../md_files/active_histidines | cut -d " " -f 2`

# set up protein ligand group
# MODIFY based on how many atoms/simulations you want to steer
gmx make_ndx -f solv_ions.gro -o index.ndx << EOF
splitat 13
splitat 14
"UPG_C1_"
name `expr $selection_lim + 1` GLC
a $his
name `expr $selection_lim + 2` HIS
"$(echo $atoms | cut -f 1 -d ' ')"
name `expr $selection_lim + 3` LIGO1
"$(echo $atoms | cut -f 2 -d ' ')"
name `expr $selection_lim + 4` LIGO2 
1 | 13 | 14

q
EOF

