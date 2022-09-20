#!/bin/bash

cd ../md/

for receptor in *
do
    cd $receptor
    chmod +x ./rmsd_job.sh
    qsub rmsd_job.sh
    cd ../
done
