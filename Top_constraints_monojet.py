import ROOT
from counting_experiment import *
# Define how a control region(s) transfer is made by defining cmodel provide, the calling pattern must be unchanged!
# First define simple string which will be used for the datacard 
model = "ttbar"
convertHistograms = []

### helper functions ###

def cmodel(cid,nam,_f,_fOut, out_ws, diag):
  # Some setup
  _fin = _f.Get("category_%s"%cid)
  _wspace = _fin.Get("wspace_%s"%cid)

  # ############################ USER DEFINED ###########################################################
  # First define the nominal transfer factors (histograms of signal/control, usually MC 
  # note there are many tools available inside include/diagonalize.h for you to make 
  # special datasets/histograms representing these and systematic effects 
  # but for now this is just kept simple 
  processName = "TTbar" # Give a name of the process being modelled
  metname = "met"    # Observable variable name 

  targetmc     = _fin.Get("signal_ttbar")      # define monimal (MC) of which process this config will model
  controlmc    = _fin.Get("muonelectron_ttbar")
  controlmc_e  = _fin.Get("electronmuon_ttbar")
  controlmc_wm = _fin.Get("singlemuonw_ttbar")
  controlmc_we = _fin.Get("singleelectronw_ttbar")
 

  # Create the transfer factors and save them (not here you can also create systematic variations of these 
  # transfer factors (named with extention _sysname_Up/Down

  TopScales = targetmc.Clone(); TopScales.SetName("topme_weights_%s"%cid)
  TopScales.Divide(controlmc); _fOut.WriteTObject(TopScales);

  TopScales_e = targetmc.Clone(); TopScales_e.SetName("topem_weights_%s"%cid)
  TopScales_e.Divide(controlmc_e); _fOut.WriteTObject(TopScales_e);

  TopScales_wm = targetmc.Clone(); TopScales_wm.SetName("wm_weights_%s"%cid)
  TopScales_wm.Divide(controlmc_wm); _fOut.WriteTObject(TopScales_wm);

  TopScales_we = targetmc.Clone(); TopScales_we.SetName("we_weights_%s"%cid)
  TopScales_we.Divide(controlmc_we); _fOut.WriteTObject(TopScales_we);
  #######################################################################################################

  _bins = []  # take bins from some histogram, can choose anything but this is easy 
  for b in range(targetmc.GetNbinsX()+1):
    _bins.append(targetmc.GetBinLowEdge(b+1))

  # Here is the important bit which "Builds" the control region, make a list of control regions which 
  # are constraining this process, each "Channel" is created with ...
  # 	(name,_wspace,out_ws,cid+'_'+model,TRANSFERFACTORS) 
  # the second and third arguments can be left unchanged, the others instead must be set
  # TRANSFERFACTORS are what is created above, eg TopScales

  CRs = [
   Channel("muonelectronModel",      _wspace,out_ws,cid+'_'+model,TopScales),
   Channel("electronmuonModel",  _wspace,out_ws,cid+'_'+model,TopScales_e),
   Channel("singlemuonwModel",  _wspace,out_ws,cid+'_'+model,TopScales_wm),
   Channel("singleelectronwModel",  _wspace,out_ws,cid+'_'+model,TopScales_we),
  ]


  # ############################ USER DEFINED ###########################################################
  # Add systematics in the following, for normalisations use name, relative size (0.01 --> 1%)
  # for shapes use add_nuisance_shape with (name,_fOut)
  # note, the code will LOOK for something called NOMINAL_name_Up and NOMINAL_name_Down, where NOMINAL=TopScales.GetName()
  # these must be created and writted to the same dirctory as the nominal (fDir)
 
  def addStatErrs(hx,cr,crname1,crname2):
    for b in range(1,targetmc.GetNbinsX()+1):
      err = hx.GetBinError(b)
      if not hx.GetBinContent(b)>0:
        continue
      relerr = err/hx.GetBinContent(b)
      if relerr<0.01:
        continue
      byb_u = hx.Clone(); byb_u.SetName('%s_weights_%s_%s_stat_error_%s_bin%d_Up'%(crname1,cid,cid,crname2,b-1))
      byb_u.SetBinContent(b,hx.GetBinContent(b)+err)
      byb_d = hx.Clone(); byb_d.SetName('%s_weights_%s_%s_stat_error_%s_bin%d_Down'%(crname1,cid,cid,crname2,b-1))
      if err<hx.GetBinContent(b):
        byb_d.SetBinContent(b,hx.GetBinContent(b)-err)
      else:
        byb_d.SetBinContent(b,0)
      _fOut.WriteTObject(byb_u)
      _fOut.WriteTObject(byb_d)
      cr.add_nuisance_shape('%s_stat_error_%s_bin%d'%(cid,crname2,b-1),_fOut)

  addStatErrs(TopScales,CRs[0],'topme','muonelectron')
  addStatErrs(TopScales_e,CRs[1],'topem','electronmuon')
  addStatErrs(TopScales_wm,CRs[2],'wm','singlemuonw')
  addStatErrs(TopScales_we,CRs[3],'we','singleelectronw')
  

  #######################################################################################################

  cat = Category(model,cid,nam,_fin,_fOut,_wspace,out_ws,_bins,metname,targetmc.GetName(),CRs,diag)
  #cat.setDependant("wjets","ttbarsignal")  # Can use this to state that the "BASE" of this is already dependant on another process
  # EG if the W->lv in signal is dependant on the Z->vv and then the W->mv is depenant on W->lv, then 
  # give the arguments model,channel name from the config which defines the Z->vv => W->lv map! 
  # Return of course
  return cat

