# import argparse
# parser = argparse.ArgumentParser()
# parser.add_argument('n_mol', metavar='N', type=int,
#                     help='number of ligand mol N')

# args = parser.parse_args()

top_file = 'topol.top'

include_ff = '#include "../../amber14sb.ff/forcefield.itp"\n'
include_ions = '#include "../../amber14sb.ff/ions.itp"\n'
include_water = '#include "../../amber14sb.ff/tip3p.itp"\n'

include_upg_topology = '; Include ligand topology\n#include "upg.itp"\n'
include_phl_topology = '; Include ligand topology\n#include "phl.itp"\n'

include_upg_res = '; Ligand position restraints\n#ifdef POSRES_LIG\n#include "posre_upg.itp"\n#endif\n'
include_phl_res = '; Ligand position restraints\n#ifdef POSRES_LIG\n#include "posre_phl.itp"\n#endif\n'

include_mol_upg = f'UPG                 1\n'
include_mol_phl = f'PHL                 1\n'

with open('topol_complex.top','w') as fo:
    with open(top_file,'r') as fh:
        lines = fh.readlines()
        for line in lines:
            if line.strip() == '#include "amber14sb.ff/forcefield.itp"':
                fo.write(include_ff)
                fo.write('\n')
                fo.write(include_upg_topology)
                fo.write('\n')
                fo.write(include_upg_res)
                fo.write('\n')
                fo.write(include_phl_topology)
                fo.write('\n')
                fo.write(include_phl_res)
                fo.write('\n')
            elif line.strip() == '#include "amber14sb.ff/tip3p.itp"':
                fo.write(include_water)
                fo.write('\n')
            elif line.strip() == '#include "amber14sb.ff/ions.itp"':
                fo.write(include_ions)
                fo.write('\n')
            else:
                fo.write(line)
        fo.write(include_mol_upg)
        fo.write(include_mol_phl)
