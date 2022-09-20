#!/bin/bash
### pass time in ps as a first argument

cd ../md

for receptor in *
do
    cd $receptor
    sed -i -e 's\-extend 20000\-extend '$1'\g' extend_md.sh
    cd ..
done
