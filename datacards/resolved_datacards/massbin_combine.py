#!/bin/python

import os
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("massbin",type=str,help="Specify mass bin")
args = parser.parse_args()
#cwd = os.getcwd()

naming={
    #config files                            #CR/SR
    "boosted_dielectron_control"             : ["zee"],
    "boosted_dielectron_fail_control"        : ["zee_fail"],
    "boosted_dimuon_control"                 : ["zmm"],
    "boosted_dimuon_fail_control"            : ["zmm_fail"],
    "boosted_signal"                         : ["sig"],
    "boosted_signal_fail"                    : ["sig_fail"],
    "boosted_singleelectrontop_control"      : ["ten"],
    "boosted_singleelectrontop_fail_control" : ["ten_fail"],
    "boosted_singleelectronw_control"        : ["wen"],
    "boosted_singleelectronw_fail_control"   : ["wen_fail"],
    "boosted_singlemuontop_control"          : ["tmn"],
    "boosted_singlemuontop_fail_control"     : ["tmn_fail"],
    "boosted_singlemuonw_control"            : ["wmn"],
    "boosted_singlemuonw_fail_control"       : ["wmn_fail"],
}
command=["combineCards.py"]
for datacard in os.listdir("./"):
    if datacard.endswith(".txt"):
        if datacard == "boosted_datacard.txt" or datacard == "combined_mass0.txt" or not datacard.startswith('boosted'):
            continue
        #print datacard.split('.')[0]
        command.append(args.massbin+"_"+naming[datacard.split('.')[0]][0]+"=./"+datacard)
        #command.append(naming[datacard.split('.')[0]][0]+"=./"+args.massbin+"/"+datacard)
        
command.append("> combine_"+args.massbin+".txt")
print ' '.join(command)

