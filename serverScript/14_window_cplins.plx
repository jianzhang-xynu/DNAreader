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

for($count=0;$count<@file;$count++){

	open PROD54,"$taskID/couplingsFeas/$count.addWdprod54";
	chomp(@prod54=<PROD54>);
	close PROD54;

	$prolen=@prod54;

	open WRITE,">$taskID/couplingsFeas/$count.windcplins54";
	for($cn=0;$cn<$prolen;$cn++){
		@currline=split(/,/,@prod54[$cn]);
		$currposi=$cn;
		for($cm=$currposi+5;$cm<=$currposi+9;$cm++){
			print WRITE @currline[$cm].",";
		}
		print WRITE "\n";
	}
	close WRITE;
}

for($count=0;$count<@file;$count++){

	open PROD80,"$taskID/couplingsFeas/$count.addWdprod80";
	chomp(@prod80=<PROD80>);
	close PROD80;

	$prolen=@prod80;

	open WRITE,">$taskID/couplingsFeas/$count.windcplins80";
	for($cn=0;$cn<$prolen;$cn++){
		@currline=split(/,/,@prod80[$cn]);
		$currposi=$cn;
		for($cm=$currposi+5;$cm<=$currposi+9;$cm++){
			print WRITE @currline[$cm].",";
		}
		print WRITE "\n";
	}
	close WRITE;
}

