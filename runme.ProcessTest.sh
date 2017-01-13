#!/bin/bash
set -e
if [ $# -ne 2 ];then
    echo "Usage:"$0" PhysList macrofile"
    exit 1
fi

echo "Running ProcessTest version: "`ProcessTest --version`" in: "`pwd`
echo "Geant4 Version:"`geant4-config --version`

ProcessTest -f CSV -p $1 $2

#Copy output files
cond=`echo $2 | sed 's/validation\///' | sed 's/\/run.mac//' | sed 's/\//-/g'`
mkdir -p /output
#If switching to ROOT/AIDA format add output, change .csv with appropriate
tar czf /output/${1}-${conf}.tgz *.csv *.json *.ps  

