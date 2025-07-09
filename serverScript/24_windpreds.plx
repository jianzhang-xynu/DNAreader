#! /usr/bin/perl

$taskID=$ARGV[0];

opendir DIR,"$taskID/fastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;

for($cn=0;$cn<@file;$cn++){
	open PREDVALUE,"$taskID/step2feas/$cn.addpred";
	chomp(@predValue=<PREDVALUE>);
	close PREDVALUE;

	$predValuelen=@predValue;
	
	open WRITE,">$taskID/step2feas/$cn.predfeas";
	for($count=17;$count<$predValuelen-17;$count++){

		printf WRITE ("%4.3f ",@predValue[$count-4]);
		printf WRITE ("%4.3f ",@predValue[$count-3]);
		printf WRITE ("%4.3f ",@predValue[$count-2]);
		printf WRITE ("%4.3f ",@predValue[$count-1]);
		printf WRITE ("%4.3f ",@predValue[$count]);
		printf WRITE ("%4.3f ",@predValue[$count+1]);
		printf WRITE ("%4.3f ",@predValue[$count+2]);
		printf WRITE ("%4.3f ",@predValue[$count+3]);
		printf WRITE ("%4.3f\n",@predValue[$count+4]);
	}
	close WRITE;
}


