#!/bin/bash
set -e

cd /usr/local/geant4/applications/share/ProcessTest/validation/crosssections/
echo "Running ProcessTest version: "`ProcessTest --version`" in: "`pwd`

echo "EM Cross-sections"
./doXS_EM.sh
echo "Had Cross-sections"
./doXS_had.sh

#Copy output files
tar czf output.tgz *.log *.json

#Copy to final location
