#! /usr/bin/perl

$taskID=$ARGV[0];

system "mkdir -p $taskID/couplingsFeas/";

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

for($count=0;$count<@file;$count++){

	open PROD54,"$taskID/couplings/$count.completeprod54";
	chomp(@prod54=<PROD54>);
	close PROD54;

	open WRITE,">$taskID/couplingsFeas/$count.addWdprod54";
	for($cn=0;$cn<@prod54;$cn++){
		@currProd=split(/,/,@prod54[$cn]);
		$currlen=@currProd;

		print WRITE @currProd[6].",";
		print WRITE @currProd[5].",";
		print WRITE @currProd[4].",";
		print WRITE @currProd[3].",";
		print WRITE @currProd[2].",";
		print WRITE @currProd[1].",";
		print WRITE @currProd[0].",";

		for($cm=0;$cm<@currProd;$cm++){
			print WRITE @currProd[$cm].",";
		}
		print WRITE @currProd[$currlen-1].",";
		print WRITE @currProd[$currlen-2].",";
		print WRITE @currProd[$currlen-3].",";
		print WRITE @currProd[$currlen-4].",";
		print WRITE @currProd[$currlen-5].",";
		print WRITE @currProd[$currlen-6].",";
		print WRITE @currProd[$currlen-7]."\n";
	}
	close WRITE;
}

for($count=0;$count<@file;$count++){

	open PROD80,"$taskID/couplings/$count.completeprod80";
	chomp(@prod80=<PROD80>);
	close PROD80;

	open WRITE,">$taskID/couplingsFeas/$count.addWdprod80";
	for($cn=0;$cn<@prod80;$cn++){
		@currProd=split(/,/,@prod80[$cn]);
		$currlen=@currProd;

		print WRITE @currProd[6].",";
		print WRITE @currProd[5].",";
		print WRITE @currProd[4].",";
		print WRITE @currProd[3].",";
		print WRITE @currProd[2].",";
		print WRITE @currProd[1].",";
		print WRITE @currProd[0].",";

		for($cm=0;$cm<@currProd;$cm++){
			print WRITE @currProd[$cm].",";
		}
		print WRITE @currProd[$currlen-1].",";
		print WRITE @currProd[$currlen-2].",";
		print WRITE @currProd[$currlen-3].",";
		print WRITE @currProd[$currlen-4].",";
		print WRITE @currProd[$currlen-5].",";
		print WRITE @currProd[$currlen-6].",";
		print WRITE @currProd[$currlen-7]."\n";
	}
	close WRITE;
}



