#! /usr/bin/perl

$taskID=$ARGV[0];

system "cp $taskID/feasfolder/0.txt $taskID/feasfolder/temp_pro.computedfeas";
system "cp $taskID/fastas/0.txt $taskID/temp_pro.fasta";

system "python3 forWebUse.py $taskID";

system "mkdir -p $taskID/preds/";

system "mv $taskID/temp_pro.tempPred $taskID/preds/0.tempPred";


