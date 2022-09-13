""" script to remove [ atomtypes ] from lig.itp
note that this section must still be present in upg.itp
The idea is that gromacs only allows [ atomtypes ] section
to appear once in complete topology file, so all atom type 
descriptors have to be in a single section (i.e. upg.itp file)
 """
import sys

lig = sys.argv[1]

with open(f'{lig}.itp', 'w') as fo:
    with open(f'{lig}x.itp', 'r') as fh:
        lines = fh.readlines()
        i = 0
        while i < len(lines):
            if lines[i].strip() == '[ atomtypes ]':
                while True:
                    i+=1
                    if lines[i].strip() == '[ moleculetype ]':
                        break
            else:
                fo.write(lines[i])
                i+=1
                    
