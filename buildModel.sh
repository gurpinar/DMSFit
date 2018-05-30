#!/bin/bash

echo $1
if [[ "$1" == "monojet" ]]
then
    python buildModel.py $1
else
    for mass in 0 1 2 3 ; do
	python buildModel.py $1 --mass $mass
    done
fi
hadd $1.root *$1*.root