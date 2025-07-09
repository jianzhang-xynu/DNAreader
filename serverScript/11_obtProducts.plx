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

$thres54=0.54;
$thres80=0.80;

for($cn=0;$cn<@file;$cn++){

	open CSV54,"$taskID/couplings/$cn.fd54";
	chomp(@csv54=<CSV54>);
	close CSV54;
	$prolen=@csv54;

	open DIST54,"$taskID/couplings/$cn.dist54";
	chomp(@dist54=<DIST54>);
	close DIST54;

	open SMC54,"$taskID/couplings/$cn.smc54";
	chomp(@smc54=<SMC54>);
	close SMC54;

	open WRITE,">$taskID/couplings/$cn.prod54";
	for($ci=0;$ci<$prolen;$ci++){
		@currdist=split(/,/,@dist54[$ci]);
		@currsmc=split(/,/,@smc54[$ci]);

		$scorelen=@currdist;
		$newValue=0;

		for($cm=0;$cm<$scorelen;$cm++){
			$newValue=@currdist[$cm]*@currsmc[$cm];
			printf WRITE ("%4.3f,",$newValue);
		}
		print WRITE "\n";
	}	
	close WRITE;
}


for($cn=0;$cn<@file;$cn++){

	open CSV80,"$taskID/couplings/$cn.fd80";
	chomp(@csv80=<CSV80>);
	close CSV80;
	$prolen=@csv80;

	open DIST80,"$taskID/couplings/$cn.dist80";
	chomp(@dist80=<DIST80>);
	close DIST80;

	open SMC80,"$taskID/couplings/$cn.smc80";
	chomp(@smc80=<SMC80>);
	close SMC80;

	open WRITE,">$taskID/couplings/$cn.prod80";
	for($ci=0;$ci<$prolen;$ci++){
		@currdist=split(/,/,@dist80[$ci]);
		@currsmc=split(/,/,@smc80[$ci]);

		$scorelen=@currdist;
		$newValue=0;

		for($cm=0;$cm<$scorelen;$cm++){
			$newValue=@currdist[$cm]*@currsmc[$cm];
			printf WRITE ("%4.3f,",$newValue);
		}
		print WRITE "\n";
	}	
	close WRITE;
}
