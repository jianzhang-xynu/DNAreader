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

	open READ,"$taskID/preds/$cn.tempPred";
	chomp(@array=<READ>);
	close READ;

	$prolen=@array;

	open WRITE,">$taskID/preds/$cn.normalPred";
	for($ck=0;$ck<$prolen;$ck++){
		my $normalPreds = @array[$ck]*1.45;
		printf WRITE ("%5.4f\n", $normalPreds);
	}

	close WRITE;
}



