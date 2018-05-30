text2workspace.py ${1}.txt -m 125
combineTool.py -M Impacts -d ${1}.root -m 125 --doInitialFit --robustFit 1 -t -1
combineTool.py -M Impacts -d ${1}.root -m 125 --robustFit 1 --doFits -t -1
combineTool.py -M Impacts -d ${1}.root -m 125 -o impacts.json
plotImpacts.py -i impacts.json -o impacts