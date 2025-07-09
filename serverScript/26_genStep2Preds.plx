#! /usr/bin/perl

$taskID=$ARGV[0];

system "mkdir -p $taskID/2ndpreds";

open FSLIST,"feaSelectIndex/FSIndex.DNA" or die "fslist error\n";
chomp(@fslist=<FSLIST>);
close FSLIST;

open MODEL,"feaSelectIndex/FSIndexWeights.model" or die "model error\n";
chomp(@model=<MODEL>);
close MODEL;

opendir DIR,"$taskID/fastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;

for($cn=0;$cn<@file;$cn++){
	open LINES,"$taskID/step2feas/$cn.combfeas" or die "features error\n";
	chomp(@lines=<LINES>);
	close LINES;
	
	for($countlines=0;$countlines<@lines;$countlines++){
		my @values=split(/\s+/,@lines[$countlines]);
		
		#$thispred=0;
		$thispred=@model[0];
		for($countfslist=0;$countfslist<@fslist;$countfslist++){
			$thispred=$thispred+@values[@fslist[$countfslist]-1]*@model[$countfslist+1];
		}
		$thispred=1/(1+exp(-$thispred));

		#$normalizedPred=($thispred-$minPred)/($maxPred-$minPred);
		#if($normalizedPred>1){$normalizedPred=1;}
	
		open WRITE,">>$taskID/2ndpreds/$cn.2ndpreds";
		printf WRITE ("%5.4f\n", $thispred);
		close WRITE;
	}
}


