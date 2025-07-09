#! /usr/bin/perl

$taskID=$ARGV[0];

system "mkdir -p $taskID/temppcfeas/";

sub phyChem2Values{
		
	$thisAA= $_[0];
	if($thisAA eq "A"){$thisvalue = "0.30,0.45,0.11,0,0";}#
	if($thisAA eq "R"){$thisvalue = "0.76,1.00,0.71,1,0";}#
	if($thisAA eq "N"){$thisvalue = "0.03,0.56,0.33,0,0";}#
	if($thisAA eq "D"){$thisvalue = "1.00,0.92,0.26,0,1";}#
	if($thisAA eq "C"){$thisvalue = "0.66,0.38,0.31,0,0";}#

	if($thisAA eq "Q"){$thisvalue = "0.60,0.56,0.44,0,0";}#
	if($thisAA eq "E"){$thisvalue = "0.05,0.92,0.37,0,1";}#
	if($thisAA eq "G"){$thisvalue = "0.04,0.53,0.00,0,0";}#
	if($thisAA eq "H"){$thisvalue = "0.19,0.45,0.56,1,0";}#
	if($thisAA eq "I"){$thisvalue = "0.00,0.25,0.45,0,0";}#

	if($thisAA eq "L"){$thisvalue = "0.00,0.25,0.45,0,0";}#
	if($thisAA eq "K"){$thisvalue = "0.29,1.00,0.54,1,0";}#
	if($thisAA eq "M"){$thisvalue = "0.65,0.33,0.54,0,0";}#
	if($thisAA eq "F"){$thisvalue = "0.75,0.14,0.71,0,0";}#
	if($thisAA eq "P"){$thisvalue = "0.16,0.31,0.32,0,0";}#

	if($thisAA eq "S"){$thisvalue = "0.66,0.58,0.15,0,0";}#
	if($thisAA eq "T"){$thisvalue = "0.74,0.47,0.26,0,1";}#
	if($thisAA eq "W"){$thisvalue = "0.43,0.00,1.00,0,0";}#
	if($thisAA eq "Y"){$thisvalue = "0.41,0.17,0.73,0,0";}#
	if($thisAA eq "V"){$thisvalue = "0.05,0.30,0.34,0,0";}#

	if($thisAA eq "X"){$thisvalue = "-1,-1,-1,-1,-1";}

	return $thisvalue;
}

opendir DIR,"$taskID/fastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;

for($cn=0;$cn<@file;$cn++){

	open READ,"$taskID/fastas/$cn.txt";
	chomp(@array=<READ>);
	close READ;

	@callen=split(//,@array[1]);
	$AAlength=0;
	for($iteration=0;$iteration<@callen;$iteration++){
		if(@callen[$iteration] =~ /[A-Z]/){
			$AAlength=$AAlength+1;
		}
	}

	@AA=split(//,@array[1]);

	open PHYCHEM,">$taskID/temppcfeas/$cn.txt";
	for($count=0;$count<$AAlength;$count++){
		my $thisAA=phyChem2Values(@AA[$count]);
		print PHYCHEM $thisAA."\n";
	}
	close PHYCHEM;
}

