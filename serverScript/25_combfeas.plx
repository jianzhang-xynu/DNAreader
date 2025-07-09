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
	open PRED,"$taskID/step2feas/$cn.predfeas";
	chomp(@predfeas=<PRED>);
	close PRED;

	$prolen=@predfeas;

	open DISOFEASLONG,"$taskID/step2feas/$cn.longfeas" or die "disolongfeas error\n";
	chomp(@disofeaslong=<DISOFEASLONG>);
	close DISOFEASLONG;

	open DISOFEASSHORT,"$taskID/step2feas/$cn.shortfeas" or die "disoshortfeas error\n";
	chomp(@disofeasshort=<DISOFEASSHORT>);
	close DISOFEASSHORT;

	open WRITE,">$taskID/step2feas/$cn.combfeas";
	for($ck=0;$ck<$prolen;$ck++){
		print WRITE @predfeas[$ck]." ".@disofeasshort[$ck]." ".@disofeaslong[$ck]."\n";
	}
	close WRITE;
}


