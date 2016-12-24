#!/bin/bash
set -e
if [ $# -ne 2 ];then
    echo "Usage:"$0" PhysList macrofile"
    exit 1
fi
echo "Geant4 Version:"`geant4-version --config`
echo "ProcessTest version:"`ProcessTest --version`"
exec ProcessTest -p $1 $2
