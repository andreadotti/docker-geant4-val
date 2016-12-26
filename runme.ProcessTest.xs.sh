#!/bin/bash
set -e

#Check if all or part of materials are expected
if [ $# -ge 1 ];then
   segment=$1
   if [ $# -ge 2 ];then
      totsegms=$1
   else
      totsegms=10
   fi
fi
echo "Running ProcessTest version: "`ProcessTest --version`" in: "`pwd`

cd crosssections
echo "EM Cross-sections"
./doXS_EM.sh $totsegms $segment
echo "Had Cross-sections"
./doXS_had.sh $totsegms $segment

#Copy output files
mkidr -p /output
tar czf /output/crosssections${segment}.tgz *.log *.json

#Copy to final location
