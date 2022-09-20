#!/bin/bash

cd ../md

for receptor in *
do
    cd $receptor
    chmod +x rmsd.sh
    cd ..
done
