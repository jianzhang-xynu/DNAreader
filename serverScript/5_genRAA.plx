#! /usr/bin/perl

$taskID=$ARGV[0];

system "mkdir -p $taskID/tempRAACfeas/";

sub AAC2Values{
		
	$thisAA= $_[0];
	if($thisAA eq "A"){$thisvalue = "-0.269,-0.178";}
	if($thisAA eq "R"){$thisvalue = "1.605,1.342";}
	if($thisAA eq "N"){$thisvalue = "0.008,0.038";}
	if($thisAA eq "D"){$thisvalue = "-0.394,-0.489";}
	if($thisAA eq "C"){$thisvalue = "-0.482,-0.643";}

	if($thisAA eq "Q"){$thisvalue = "0.070,0.061";}
	if($thisAA eq "E"){$thisvalue = "-0.287,-0.409";}
	if($thisAA eq "G"){$thisvalue = "-0.049,-0.086";}
	if($thisAA eq "H"){$thisvalue = "0.651,0.056";}
	if($thisAA eq "I"){$thisvalue = "-0.322,-0.047";}

	if($thisAA eq "L"){$thisvalue = "-0.480,-0.335";}
	if($thisAA eq "K"){$thisvalue = "1.156,1.211";}
	if($thisAA eq "M"){$thisvalue = "-0.193,-0.137";}
	if($thisAA eq "F"){$thisvalue = "-0.172,-0.109";}
	if($thisAA eq "P"){$thisvalue = "-0.273,-0.313";}

	if($thisAA eq "S"){$thisvalue = "0.076,0.007";}
	if($thisAA eq "T"){$thisvalue = "0.084,0.156";}
	if($thisAA eq "W"){$thisvalue = "-0.284,-0.398";}
	if($thisAA eq "Y"){$thisvalue = "0.194,0.123";}
	if($thisAA eq "V"){$thisvalue = "-0.357,-0.206";}

	if($thisAA eq "X"){$thisvalue = "0.000,0.000";}

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

	open PHYCHEM,">$taskID/tempRAACfeas/$cn.txt";
	for($count=0;$count<$AAlength;$count++){
		my $thisAA=AAC2Values(@AA[$count]);
		print PHYCHEM $thisAA."\n";
	}
	close PHYCHEM;
}

