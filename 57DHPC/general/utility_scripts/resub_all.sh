#!/bin/bash

cd ../md/

for receptor in *
do
    cd $receptor
    chmod +x re_job.sh
    qsub re_job.sh
    cd ../
done
