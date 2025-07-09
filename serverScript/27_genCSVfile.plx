#! /usr/bin/perl

$taskID=$ARGV[0];

opendir DIR,"$taskID/fastas";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;

open NAME,"$taskID/name.txt";
chomp(@taskRealName=<NAME>);
close NAME;

open WRITE,">$taskID/result.csv";
for($cn=0;$cn<@file;$cn++){
	print WRITE @taskRealName[$cn]."\n";
	print WRITE "Residue Number,Residue Type,Predicted DNA-binding probabilities, Refined probabilities by step2\n";

	open FASTA,"$taskID/orgifastas/$cn.txt";
	chomp(@temp=<FASTA>);
	close FASTA;
	@fasta=split(//,@temp[1]);

	open STEP1,"$taskID/preds/$cn.normalPred";
	chomp(@step1pred=<STEP1>);
	close STEP1;

	open STEP2,"$taskID/2ndpreds/$cn.2ndpreds";
	chomp(@step2pred=<STEP2>);
	close STEP2;
	
	for($count=0;$count<@step1pred;$count++){
		$thisResiduesNumber=$count+1;
		print WRITE $thisResiduesNumber.",";
		print WRITE @fasta[$count].",";

		print WRITE @step1pred[$count].",";
		print WRITE @step2pred[$count];
		print WRITE "\n";
	}
}
close WRITE;


	
	





