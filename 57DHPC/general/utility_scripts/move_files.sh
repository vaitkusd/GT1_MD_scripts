#!/bin/bash

cd ../md

for receptor in *
do
    cp ../rmsd_job.sh $receptor
    sed -i -e 's\XXX\'$receptor'\g' $receptor/rmsd_job.sh
done
