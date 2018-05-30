#!/bin/bash

massbin=$1

samples_hsdm=(hsDM-1000-50-100 hsDM-1000-50-200 hsDM-1000-50-250 hsDM-1000-50-300)
#samples_hsdm=(hsDM-1000-50-100 hsDM-1000-50-200 hsDM-1000-50-250)
#samples_hsdm=(hsDM-1000-50-200)
#samples_Zpdm=(ZpDM-1000-150-10 ZpDM-1000-50-10 ZpDM-100-150-10 ZpDM-100-50-10 ZpDM-1500-150-10 ZpDM-1500-50-10 ZpDM-2000-150-10 ZpDM-2000-50-10 ZpDM-2500-150-10 ZpDM-3000-150-10 ZpDM-3000-50-10 ZpDM-300-150-10)
samples_Zpdm=(ZpDM-1000-150-10 ZpDM-2000-50-10 ZpDM-3000-150-10)
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
