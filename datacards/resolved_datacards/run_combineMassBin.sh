#!/bin/bash
echo "Combining datacard-let into combine_massX.txt in each massbin folder"
dir=`pwd`
for massbin in mass0 mass1 mass2 mass3
do
    eval cd $dir
    scp massbin_combine.py ./$massbin
    eval cd ./$massbin
    comx=`(python massbin_combine.py $massbin)`
    echo $comx > run.sh
    chmod 775 run.sh
    rm massbin_combine.py
    sh run.sh
done
echo "DONE"