#!/bin/bash

echo "Launching Megascript"
sleep 3
#
sh run_combineMassBin.sh
rm MASS/*
scp mass0/combine_mass0.txt mass1/combine_mass1.txt mass2/combine_mass2.txt mass3/combine_mass3.txt MASS

eval cd MASS; combineCards.py combine_mass0.txt combine_mass1.txt combine_mass2.txt combine_mass3.txt > combine_all.txt
eval cd ..
echo "Populating MASS folder"
ls MASS
sleep 3

#for mass in MASS
#do
#    scp scan_hszp.sh ${mass}/scan_hszp.sh
#    eval cd $mass

#    if [ $mass == "MASS" ];then
#	echo "sh scan_hszp.sh all"
#	sleep 2
#	sh scan_hszp.sh all
#    else
#	echo "sh scan_hszp.sh $mass"
#	sleep 2
#	sh scan_hszp.sh $mass
#    fi
#    rm scan_hszp.sh

#done
#echo "DONE"
