#! /usr/bin/perl


$taskID=$ARGV[0];
#$taskID="2025";

#obtain original FASTA-formatted file
system "perl serverScript/0_split.plx $taskID";
print "step 0 is done.\n";
#run third-party software
system "perl serverScript/1_genRSA.plx $taskID";
print "step 1 is done.\n";
system "perl serverScript/2_genECO.plx $taskID";
print "step 2 is done.\n";
system "perl serverScript/3_genDISO.plx $taskID";
print "step 3 is done.\n";
system "perl serverScript/4_genPC.plx $taskID";
print "step 4 is done.\n";
system "perl serverScript/5_genRAA.plx $taskID";
print "step 5 is done.\n";
system "perl serverScript/6_runCLIP.plx $taskID";
print "step 6 is done.\n";

#compute evolutionary couplings
system "perl serverScript/7_calSeqWeights.plx $taskID";
print "step 7 is done.\n";
system "perl serverScript/8_findConserved.plx $taskID";
print "step 8 is done.\n";
system "perl serverScript/9_comptdistance.plx $taskID";
print "step 9 is done.\n";
system "perl serverScript/10_comptSpmC.plx $taskID";
print "step 10 is done.\n";
system "perl serverScript/11_obtProducts.plx $taskID";
print "step 11 is done.\n";
system "perl serverScript/12_completeProds.plx $taskID";
print "step 12 is done.\n";

#step 1 features
system "perl serverScript/13_addwindow.plx $taskID";
print "step 13 is done.\n";
system "perl serverScript/14_window_cplins.plx $taskID";
print "step 14 is done.\n";

system "perl serverScript/15_windPCFeas.plx $taskID";
print "step 15 is done.\n";
system "perl serverScript/16_windRAAFeas.plx $taskID";
print "step 16 is done.\n";
system "perl serverScript/17_windFeas.plx $taskID";
print "step 17 is done.\n";
system "perl serverScript/18_combfeas.plx $taskID";
print "step 18 is done.\n";


#step 1 model
system "perl serverScript/19_runModel.plx $taskID";
print "step 19 is done.\n";

#step 2 features
system "perl serverScript/20_normalPreds.plx $taskID";
print "step 20 is done.\n";
system "perl serverScript/21_addWind.plx $taskID";
print "step 21 is done.\n";
system "perl serverScript/22_addWind.plx $taskID";
print "step 22 is done.\n";
system "perl serverScript/23_winddisos.plx $taskID";
print "step 23 is done.\n";
system "perl serverScript/24_windpreds.plx $taskID";
print "step 24 is done.\n";
system "perl serverScript/25_combfeas.plx $taskID";
print "step 25 is done.\n";

#step 2 model
system "perl serverScript/26_genStep2Preds.plx $taskID";
print "step 26 is done.\n";


#Final results
system "perl serverScript/27_genCSVfile.plx $taskID";
print "step 27 is done.\n";

