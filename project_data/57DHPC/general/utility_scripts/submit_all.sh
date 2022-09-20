#!/bin/bash

cd ../md/

for receptor in *
do
    cd $receptor
    chmod +x ./job.sh
    qsub job.sh
    cd ../
done
