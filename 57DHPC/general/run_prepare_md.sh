#!/bin/bash

curWD=`pwd`
# setup to write the output to a file
readonly LOG_FILE="./script.log"
# remove previous leftovers
rm $LOG_FILE
touch $LOG_FILE
exec &> >(tee -ia $LOG_FILE)
sleep .1

cd md/

# for each receptor
for receptor in *
do
    cd $receptor 
    chmod +x ./prepare_md.sh
    source prepare_md.sh      
    cd ../
done

cd $curWD

errors=`grep "[eE]rror" "script.log" | wc -l`

echo "#########################################################"
echo "##### $errors Errors encountered when running the script #####"
echo "#########################################################"

