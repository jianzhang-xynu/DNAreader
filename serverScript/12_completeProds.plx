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

	open POSI54,"$taskID/couplings/$cn.posi54";
	chomp(@posi54=<POSI54>);
	close POSI54;
	
	open PRODS54,"$taskID/couplings/$cn.prod54";
	chomp(@prods54=<PRODS54>);
	close PRODS54;

	$prolen=@prods54;

	open WRITE,">$taskID/couplings/$cn.completeprod54";
	for($ct=0;$ct<$prolen;$ct++){
		@currlineProds=();
		for($cm=0;$cm<$prolen;$cm++){
			push(@currlineProds,"-1");
		}

		@haveProds=split(/,/,@prods54[$ct]);

		for($ck=0;$ck<@haveProds;$ck++){
			$realposi54=@posi54[$ck];
			@currlineProds[$realposi54]=@haveProds[$ck];
		}
		for($ch=0;$ch<$prolen;$ch++){
			print WRITE @currlineProds[$ch].",";
		}
		print WRITE "\n";
	}	
	close WRITE;
}


for($cn=0;$cn<@file;$cn++){

	open POSI80,"$taskID/couplings/$cn.posi80";
	chomp(@posi80=<POSI80>);
	close POSI80;
	
	open PRODS80,"$taskID/couplings/$cn.prod80";
	chomp(@prods80=<PRODS80>);
	close PRODS80;

	$prolen=@prods80;

	open WRITE,">$taskID/couplings/$cn.completeprod80";
	for($ct=0;$ct<$prolen;$ct++){
		@currlineProds=();
		for($cm=0;$cm<$prolen;$cm++){
			push(@currlineProds,"-1");
		}

		@haveProds=split(/,/,@prods80[$ct]);

		for($ck=0;$ck<@haveProds;$ck++){
			$realposi80=@posi80[$ck];
			@currlineProds[$realposi80]=@haveProds[$ck];
		}
		for($ch=0;$ch<$prolen;$ch++){
			print WRITE @currlineProds[$ch].",";
		}
		print WRITE "\n";
	}	
	close WRITE;
}
