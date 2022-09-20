import os
from shutil import copyfile, copytree
#import numpy as np

# change according to acceptor
lig = 'hmc'

if not os.path.exists("md"):
    os.mkdir("md")

for receptor in os.listdir('receptors'):
    # working directory and base id
    cur_id = receptor[:-4]
      

    cur_md_dir = os.path.join("md", cur_id)
    if not os.path.exists(cur_md_dir):
        os.mkdir(cur_md_dir)   	
    
    # copy in relevant files
    #####################
    # receptor
    copyfile(f'receptors/{cur_id}.pdb',
             f'{cur_md_dir}/receptor.pdb')
             
    #####################
    # phloretin
    copyfile(f'acceptors/{lig}_{cur_id}.pdb',
             f'{cur_md_dir}/{lig}.pdb')
    
    # upg gro
    copyfile(f'upg/upg.gro',
             f'{cur_md_dir}/upg.gro')
    
    # upg itp
    copyfile(f'upg/upg.itp',
             f'{cur_md_dir}/upg.itp')
    
    #####################
    # pbsa.mdp
    #copyfile(f'md_files/pbsa.mdp',
    #         f'{cur_md_dir}/pbsa.mdp')
    
    # calc_binding_energy.sh
    #copyfile(f'md_files/calc_binding_energy.sh',
    #         f'{cur_md_dir}/calc_binding_energy.sh')
    
    # MmPbSaStat.py
    #copyfile(f'md_files/MmPbSaStat.py',
    #         f'{cur_md_dir}/MmPbSaStat.py')
    
    # rmsd.sh
    copyfile(f'md_files/rmsd.sh',
             f'{cur_md_dir}/rmsd.sh')
             

    ####################   
    # MDP
    copytree(f'md_files/MDP', 
             f'{cur_md_dir}/MDP')
    
    ####################
    # create_complex
    copyfile(f'md_files/create_complex.py',
             f'{cur_md_dir}/create_complex.py')
    
    # prepare_md.sh
    copyfile(f'md_files/prepare_md.sh', 
             f'{cur_md_dir}/prepare_md.sh')
    
    # prepare_top.py
    copyfile(f'md_files/prepare_top.py',
             f'{cur_md_dir}/prepare_top.py')
    
    # fix_phl_top.py         
    copyfile(f'md_files/fix_lig_top.py',
             f'{cur_md_dir}/fix_lig_top.py')
    
    # extract_phl_atoms.py         
    copyfile(f'md_files/extract_steer_atoms.py',
             f'{cur_md_dir}/extract_steer_atoms.py')
             
    # run_md.sh
    copyfile(f'md_files/run_md.sh', f'{cur_md_dir}/run_md.sh')
    
    # extend_md.sh    
    copyfile(f'md_files/extend_md.sh', f'{cur_md_dir}/extend_md.sh')
    

    ####################
    # job.sh
    with open(f'md_files/job.sh', 'r') as fi:
        lines = fi.readlines()
        with open(f'{cur_md_dir}/job.sh', 'w') as fo:
            for line in lines:
                line = line.replace('XXX', f'{cur_id}')
                fo.write(line)

    ####################
    # re_job.sh
    with open(f'md_files/re_job.sh', 'r') as fi:
        lines = fi.readlines()
        with open(f'{cur_md_dir}/re_job.sh', 'w') as fo:
            for line in lines:
                line = line.replace('XXX', f'{cur_id}')
                fo.write(line)
                
    # rmsd_job.sh
    with open(f'md_files/rmsd_job.sh', 'r') as fi:
        lines = fi.readlines()
        with open(f'{cur_md_dir}/rmsd_job.sh', 'w') as fo:
            for line in lines:
                line = line.replace('XXX', f'{cur_id}')
                fo.write(line)

