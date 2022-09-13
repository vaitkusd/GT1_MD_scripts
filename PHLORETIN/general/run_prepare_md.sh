#!/bin/bash
cd md/

# for each receptor
for receptor in *
do
    cd $receptor 
    chmod +x ./prepare_md.sh
    source prepare_md.sh      
    cd ../
done
