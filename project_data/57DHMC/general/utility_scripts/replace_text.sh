#!/bin/bash

cd ../md

for receptor in *
do
    cd $receptor
    sed -i -e 's\24:00:00\36:00:00\g' re_job.sh
    cd ..
done
