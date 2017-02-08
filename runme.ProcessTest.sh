#!/bin/bash
set -e
if [ $# -ne 2 ];then
    echo "Usage:"$0" PhysList macrofile"
    exit 1
fi

#This is needed because Azure changes the Workging dir
cd /usr/local/geant4/applications/share/ProcessTest

echo "Running ProcessTest version: "`ProcessTest --version`" in: "`pwd`
echo "Geant4 Version: "`geant4-config --version`
date

#Removed initial "[./]validation/" final "/run.mac" and replace "/" with "-"
conf=`echo $2 | sed -r 's/^\.?\/?validation\///' | sed 's/\/run.mac//' | sed 's/\//-/g'`

echo "Starting, output in $PWD/${1}-${conf}.cout.log and $PWD/${1}-${conf}.cerr.log"
set +e
ProcessTest -f CSV -p $1 $2 2> >(tee $PWD/${1}-${conf}.cerr.log) 1> >(tee $PWD/${1}-${conf}.cout.log) 
set -e
echo "Done, copying output to /output/${1}-${conf}.tgz"
#Copy output files
mkdir -p /output

#Some files may be optional... Avoid script to exit immediately and 
#create list of files
set +e
files=`ls *.csv *.root *.xml *.log *.ps *.json 2> /dev/null` 
set -e
tar czf /output/${1}-${conf}.tgz ${files}
date
echo "All done, bye"
