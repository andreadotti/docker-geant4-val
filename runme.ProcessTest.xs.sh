#!/bin/bash
set -e

#Check if all or part of materials are expected
if [ $# -ge 1 ];then
   segment=$1
   if [ $# -ge 2 ];then
      totsegms=$2
   fi
fi

#This is needed because unfortunately Azure changes the working dir
cd /usr/local/geant4/applications/share/ProcessTest

cd validation
echo "Running ProcessTest version: "`ProcessTest --version`" in: "`pwd`

cd crosssections
echo "EM Cross-sections"
./doXS_EM.sh $totsegms $segment
echo "Had Cross-sections"
./doXS_had.sh $totsegms $segment

#Copy output files
mkdir -p /output
tar czf /output/crosssections${segment}.tgz *.log *.json

