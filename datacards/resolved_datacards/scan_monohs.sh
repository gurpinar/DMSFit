#!/bin/bash

massbin=$1

samples_hsdm=(hsDM-500-50-50 hsDM-500-50-100 hsDM-500-50-150 hsDM-500-50-200 hsDM-495-50-250 hsDM-500-70-50 hsDM-500-70-100 hsDM-500-70-150 hsDM-500-70-200 hsDM-495-70-250 hsDM-500-90-50 hsDM-500-90-100 hsDM-500-90-150 hsDM-500-90-200 hsDM-495-90-250 hsDM-1000-50-50 hsDM-1000-50-100 hsDM-1000-50-150 hsDM-1000-50-200 hsDM-1000-50-250 hsDM-1000-50-300 hsDM-1000-50-400 hsDM-1000-70-50 hsDM-1000-70-100 hsDM-1000-70-150 hsDM-1000-70-200 hsDM-1000-70-250 hsDM-1000-70-300 hsDM-1000-70-400 hsDM-1000-90-50 hsDM-1000-90-100 hsDM-1000-90-150 hsDM-1000-90-200 hsDM-1000-90-250 hsDM-1000-90-300 hsDM-1000-90-400 hsDM-1500-50-50 hsDM-1500-50-100 hsDM-1500-50-150 hsDM-1500-50-200 hsDM-1500-50-250 hsDM-1500-50-300 hsDM-1500-50-400 hsDM-1500-70-50 hsDM-1500-70-100 hsDM-1500-70-150 hsDM-1500-70-200 hsDM-1500-70-250 hsDM-1500-70-300 hsDM-1500-70-400 hsDM-1500-90-50 hsDM-1500-90-100 hsDM-1500-90-150 hsDM-1500-90-200 hsDM-1500-90-250 hsDM-1500-90-300 hsDM-1500-90-400 hsDM-2000-50-50 hsDM-2000-50-100 hsDM-2000-50-150 hsDM-2000-50-200 hsDM-2000-50-250 hsDM-2000-50-300 hsDM-2000-50-400 hsDM-2000-70-50 hsDM-2000-70-100 hsDM-2000-70-150 hsDM-2000-70-200 hsDM-2000-70-250 hsDM-2000-70-300 hsDM-2000-70-400 hsDM-2000-90-50 hsDM-2000-90-100 hsDM-2000-90-150 hsDM-2000-90-200 hsDM-2000-90-250 hsDM-2000-90-300 2000-90-400 hsDM-2500-50-50 hsDM-2500-50-100 hsDM-2500-50-150 hsDM-2500-50-200 hsDM-2500-50-250 hsDM-2500-50-300 hsDM-2500-50-400 hsDM-2500-70-50 hsDM-2500-70-100 hsDM-2500-70-150 hsDM-2500-70-200 hsDM-2500-70-250 hsDM-2500-70-300 hsDM-2500-70-400 hsDM-2500-90-50 hsDM-2500-90-100 hsDM-2500-90-150 hsDM-2500-90-200 hsDM-2500-90-250 hsDM-2500-90-300 hsDM-2500-90-400 hsDM-3000-50-50 hsDM-3000-50-100 hsDM-3000-50-150 hsDM-3000-50-200 hsDM-3000-50-250 hsDM-3000-50-300 hsDM-3000-50-400 hsDM-3000-70-50 hsDM-3000-70-100 hsDM-3000-70-150 hsDM-3000-70-200 hsDM-3000-70-250 hsDM-3000-70-300 hsDM-3000-70-400 hsDM-3000-90-50 hsDM-3000-90-100 hsDM-3000-90-150 hsDM-3000-90-200 hsDM-3000-90-250 hsDM-3000-90-300 hsDM-3000-90-400)
FS="hsdm"

echo "med hs dm twosigdown onesigdown exp onesigup twosigup" > limits_${FS}_${massbin}.txt

for k in "${samples_hsdm[@]}"; do
    mediatordm=${k#'hsDM-'} #500-1000
    branchingratio='1.0'
    mediator=`(echo $mediatordm | awk -F '-' '{print$1}')`
    medhs=`(echo $mediatordm | awk -F '-' '{print$2}')`
    dm=`(echo $mediatordm | awk -F '-' '{print$3}')`

    #echo "mediator = $mediator"
    #echo "medhs = $medhs"
    #echo "dm = $dm"

    cp combine_${massbin}.txt combined.txt
    sed -i 's/XX-SIGNAL-XX/'${k}'/g' combined.txt
    
    #Computing limits
    combine -M Asymptotic -t -1 combined.txt --rAbsAcc 0 --rMax 30  | tee limits_tmp.txt
    #Parsing results into textfile
    #obs=`cat limits_tmp.txt | grep 'Observed Limit: r <' | awk '{print $5}'`
    twosigdown=`cat limits_tmp.txt | grep 'Expected  2.5%: r <' | awk '{print $5}'`
    onesigdown=`cat limits_tmp.txt | grep 'Expected 16.0%: r <' | awk '{print $5}'`
    exp=`cat limits_tmp.txt | grep 'Expected 50.0%: r <' | awk '{print $5}'`
    onesigup=`cat limits_tmp.txt | grep 'Expected 84.0%: r <' | awk '{print $5}'`
    twosigup=`cat limits_tmp.txt | grep 'Expected 97.5%: r <' | awk '{print $5}'`

    rm limits_tmp.txt

    #Applying branching ratio
    #obs=`echo "scale=7 ; $obs / $branchingratio" | bc`
    onesigdown=`echo "scale=7 ; $onesigdown / $branchingratio" | bc`
    twosigdown=`echo "scale=7 ; $twosigdown / $branchingratio" | bc`
    exp=`echo "scale=7 ; $exp / $branchingratio" | bc`
    onesigup=`echo "scale=7 ; $onesigup / $branchingratio" | bc`
    twosigup=`echo "scale=7 ; $twosigup / $branchingratio" | bc`

    echo "${mediator} ${medhs} ${dm} ${twosigdown} ${onesigdown} ${exp} ${onesigup} ${twosigup}" >> limits_${FS}_${massbin}.txt

done
mv limits_${FS}_${massbin}.txt ../limits_${FS}_${massbin}.txt
rm combined.txt
