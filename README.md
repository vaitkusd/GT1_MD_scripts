# Are molecular mechanics enough to predict glycosylation specificity by glycosyltransferases?

<!-- ABOUT THE PROJECT -->
## About The Project

This repository acts as a supplementary for my thesis thesis project. It contains data used for simulations, including MD scripts, as well as plots of analyzed trajectories, a blank project to be reused, and a report itself.

### Contents

* [Thesis report](https://github.com/vaitkusd/GT1_MD_scripts/blob/main/DV_thesis_202209.pdf)
* [Scripts with data](https://github.com/vaitkusd/GT1_MD_scripts/tree/main/project_data) - everything needed to replicate the simulations.
* [Trajectory plots](https://github.com/vaitkusd/GT1_MD_scripts/tree/main/trajectory_plots) - line plots for every simulation discussed, with thresholds for reactivity indicated.
* [Blank project](https://github.com/vaitkusd/GT1_MD_scripts/tree/main/blank_project) - an empty pipeline, that could be used for other GTs and enzymes in general with minimal (optimistically) adjustments

<!-- GETTING STARTED -->
## Getting Started

This section explains on how to replicate the simulations and set up your own project.

### Prerequisites

* [GROMACS](https://manual.gromacs.org/documentation/current/install-guide/index.html)
* [acpype](https://github.com/alanwilter/acpype)
  ```sh
  conda install -c conda-forge acpype
  ```
* A [computerome](https://www.computerome.dk/wiki) account
  _(the pipeline is currently made to be run on computerome. However, it should be easily adapted for any other HPC architecture by modifying job submission files and (possibly) gromacs command line calls, depending on how it was [compiled](https://manual.gromacs.org/current/install-guide/index.html#quick-and-dirty-cluster-installation))_


## Replication of thesis work

Provided are all required files to re-run the simulations with ploretin and dihydroxycoumarin derivatives.

#### Simulations with phloretin
1. project_data/PHLORETIN contains "general" folder with the simulation parameters and all enzyme structures. Other folders contain phloretin structures corresponding to different selections for docking pose.
2. Move "phloretin" directory from simulation specific directory to general directory.
3. Run the preparations scripts from the general folder:
   ```sh
   python create_md.py
   ./run_prepare_md.sh
   ```
4. Move the newly generated "md" directory to computerome (or other), together with "amber14sb.ff" (needed just once).
5. Make sure the execution permissions for all .sh scripts are there, change the account names in the "job.sh" files and then submit the simulation:
   ```sh
   qsub job.sh
   ```
6. After simulations end, submit the rmsd jobs that also center and fit the trajectories
   ```sh
   qsub rmsd_job.sh
   ```

#### Simulations with coumarins
1. project_data/57DH[MP]C contain "general" folders with all enzyme and docked acceptor structures. Other folders contain different simulation parameters.
2. Move "md_files" directory from simulation specific directory to general directory.
3. Repeat the steps from phloretin simulations.

**NB:** UGTs 1, 10, 19, 43, 141, 149, 153, and 154 get assigned a wrong protonation state for catalytic histidine. They need to be adjusted manually. Run the preparation separately for them, adding a ```-his``` flag to the first call of ```gmx pdb2gmx``` in the prepare_md.sh file. 


## Running a new project
_TBA_
