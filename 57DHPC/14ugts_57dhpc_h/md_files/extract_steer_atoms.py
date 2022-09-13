""" Script to extract numbers of acceptor atoms to steer.
atom_str has to be manually adjusted to contain specific atom names
of specific molecule. 
If molecule is symmetrical (i.e. phloretin), atoms_target and extract 
variables also have to be adjusted.
 """

import os
import sys
from pymol import cmd
from pymol import stored
import numpy as np

# change according to acceptor
atom_str = 'resn ZIN and (n. O1 | n. O2)'
# not relevant if there's no symmetry (sys.argv[1] != 1)
atoms_target = 'resn ZIN and (n. O1 | n. O3)'

def extract_names():
    cmd.load('solv_ions.gro', 'struct')
    # atom name might differ/UPG (UDP-glucose) has to be present
    cmd.select('his_ne', 'resn HIS and name NE2 within 5 of (resn UPG and name O6)')
    
    # extract GMX compatible names of phl atoms
    cmd.select('all_lig', atom_str)
    stored.temp = []
    cmd.iterate('all_lig', 'stored.temp.append(f"{resn}_{name}_{str(ID)[0]}")')
    
    if sys.argv[1] == str(1):
        # O1+C3; O3+C5 for phloretin
        cmd.select('lig_target', atoms_target)
        
        his_xyz = cmd.get_coords('his_ne') 
        coords = cmd.get_coords('lig_target')
            
        # change return numbers based on atom_str list in alphabetical order
        # don't know if it could actually be automated, as you still need to modify all lists
        # if O1 is closer than O2
        if np.linalg.norm(coords[0] - his_xyz) < np.linalg.norm(coords[1] - his_xyz):    
            extract = [stored.temp[i] for i in (0,2,3)]
            os.environ['atoms'] = ' '.join(extract)
            print(os.getenv('atoms'))
        else:
            extract = [stored.temp[i] for i in (1,4,3)]
            os.environ['atoms'] = ' '.join(extract)
            print(os.getenv('atoms'))
    else:
        os.environ['atoms'] = ' '.join(stored.temp)
        print(os.getenv('atoms'))
        
extract_names()
