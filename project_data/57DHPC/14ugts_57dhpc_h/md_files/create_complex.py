import sys

""" Script to merge separate .gro structure files
to a single complex.gro
 """

upg = 'upg.gro'
lig = sys.argv[1] + '.gro'
receptor  = 'receptor.gro'

upg_lines = []
upg_atoms = 0
lig_lines = []
lig_atoms = 0

with open(upg,'r') as fh:
    lines = fh.readlines()
    upg_atoms = int(lines[1].strip())

    for line in lines[2:-1]:
        upg_lines.append(line)

with open(lig,'r') as fh:
    lines = fh.readlines()
    lig_atoms = int(lines[1].strip())

    for line in lines[2:-1]:
        lig_lines.append(line)
    
with open('complex.gro','w') as fo:
    with open(receptor,'r') as fh:
        lines = fh.readlines()
        receptor_atoms = int(lines[1].strip())
        total_atoms = upg_atoms + lig_atoms + receptor_atoms

        #first line
        fo.write(lines[0])

        #second
        fo.write(f' {total_atoms}\n')

        #rest of receptor
        for line in lines[2:-1]:
            fo.write(line)
        
        # upg coordinates
        for upg_line in upg_lines:
            fo.write(upg_line)
               
        # phl coordinates    
        for lig_line in lig_lines:
            fo.write(lig_line)
        
        # end line
        fo.write(lines[-1])
