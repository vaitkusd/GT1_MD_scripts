# script to remove [ atomtypes ] from phl.itp
# note that this section must still be present in upg.itp

with open('phl.itp', 'w') as fo:
    with open('phlx.itp', 'r') as fh:
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
                    
