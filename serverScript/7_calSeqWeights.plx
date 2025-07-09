#! /usr/bin/perl

$taskID=$ARGV[0];

system "mkdir -p $taskID/couplings/";

opendir DIR,"$taskID/fastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;


for($cn=0;$cn<@file;$cn++){

	$alnlist=$cn."-uniclust20-50";
	
	open READ,"$taskID/CLIPfolder/$alnlist.aln";
	chomp(@array=<READ>);
	close READ;

	@uniAA=split(//,@array[0]);
	@callen=split(//,@array[0]);
	$prolen=0;
	for($iteration=0;$iteration<@callen;$iteration++){
		if(@callen[$iteration] =~ /[A-Z]/){
			$prolen=$prolen+1;
		}
	}

	$alnNum=@array;

	open WRITE,">$taskID/couplings/$cn.seqweights";
	for($cm=0;$cm<$alnNum;$cm++){
		@curralnAA=split(//,@array[$cm]);
		$sameAA=0;
		for($ct=0;$ct<$prolen;$ct++){
			if(@uniAA[$ct] eq @curralnAA[$ct]){$sameAA=$sameAA+1;}
		}
		$fracSameAA=$sameAA/$prolen+0.38;
		if($fracSameAA > 1){$fracSameAA=1;}
		printf WRITE ("%4.3f\n",$fracSameAA);
	}
	close WRITE;

	
	open SEQWEIGS,"$taskID/couplings/$cn.seqweights";
	chomp(@seqWeights=<SEQWEIGS>);
	close SEQWEIGS;

	open WRITECSV,">$taskID/couplings/$cn.csv";#$alnNum
	for($cn4AAs=0;$cn4AAs<$prolen;$cn4AAs++){# eachline indicates the amino acids
		for($cn4alns=1;$cn4alns<$alnNum;$cn4alns++){ # each column indicates alnScores
			$thisUniAA=@uniAA[$cn4AAs];
			@curralnAA=split(//,@array[$cn4alns]);

			my $Residue1=$thisUniAA;
			my $Residue2=@curralnAA[$cn4AAs];

			my @temp=();
			my $temp1=transferAA($Residue1);
			my $temp2=transferAA($Residue2);
			push(@temp,$temp1);
			push(@temp,$temp2);

			my $score=transferblosum62(@temp);
			my $weightScore=$score*@seqWeights[$cn4alns];

			printf WRITECSV ("%3.2f,",$weightScore);
			
		}
		printf WRITECSV ("\n");
	}
	close WRITECSV;


	open WRITE,">$taskID/couplings/$cn.fracGaps";#$alnNum
	if($alnNum == 1){
		print WRITE "NA\n";
	}else{
		for($cn4AAs=0;$cn4AAs<$prolen;$cn4AAs++){
			$cntDash=0;
			for($cn4alns=1;$cn4alns<$alnNum;$cn4alns++){
				$thisUniAA=@uniAA[$cn4AAs];
				@curralnAA=split(//,@array[$cn4alns]);

				#my $Residue1=$thisUniAA;
				my $Residue2=@curralnAA[$cn4AAs];

				if($Residue2 eq "-"){$cntDash=$cntDash+1;}
			}
			my $fracDash=$cntDash/($alnNum-1);
			printf WRITE ("%4.3f\n",$fracDash);
		}
	}
	close WRITE;

}



sub transferAA{
	
	$thisAA= $_[0];
	if($thisAA eq "A"){$thisvalue = "0";}
	if($thisAA eq "R"){$thisvalue = "1";}
	if($thisAA eq "N"){$thisvalue = "2";}
	if($thisAA eq "D"){$thisvalue = "3";}
	if($thisAA eq "C"){$thisvalue = "4";}

	if($thisAA eq "Q"){$thisvalue = "5";}
	if($thisAA eq "E"){$thisvalue = "6";}
	if($thisAA eq "G"){$thisvalue = "7";}
	if($thisAA eq "H"){$thisvalue = "8";}
	if($thisAA eq "I"){$thisvalue = "9";}

	if($thisAA eq "L"){$thisvalue = "10";}
	if($thisAA eq "K"){$thisvalue = "11";}
	if($thisAA eq "M"){$thisvalue = "12";}
	if($thisAA eq "F"){$thisvalue = "13";}
	if($thisAA eq "P"){$thisvalue = "14";}

	if($thisAA eq "S"){$thisvalue = "15";}
	if($thisAA eq "T"){$thisvalue = "16";}
	if($thisAA eq "W"){$thisvalue = "17";}
	if($thisAA eq "Y"){$thisvalue = "18";}
	if($thisAA eq "V"){$thisvalue = "19";}

	if($thisAA eq "-"){$thisvalue = "20";}
	return $thisvalue;
}

sub transferblosum62{

	my($AA1,$AA2)=@_;
	@blosum62=(
	["0.53","0.20","0.13","0.13","0.27","0.20","0.20","0.27","0.13","0.20","0.20","0.20","0.20","0.13","0.20","0.33","0.27","0.07","0.13","0.27","0.00"],
	["0.20","0.60","0.27","0.13","0.07","0.33","0.27","0.13","0.27","0.07","0.13","0.40","0.20","0.07","0.13","0.20","0.20","0.07","0.13","0.07","0.00"],
	["0.13","0.27","0.67","0.33","0.07","0.27","0.27","0.27","0.33","0.07","0.07","0.27","0.13","0.07","0.13","0.33","0.27","0.00","0.13","0.07","0.00"],
	["0.13","0.13","0.33","0.67","0.07","0.27","0.40","0.20","0.20","0.07","0.00","0.20","0.07","0.07","0.20","0.27","0.20","0.00","0.07","0.07","0.00"],
	["0.27","0.07","0.07","0.07","0.87","0.07","0.00","0.07","0.07","0.20","0.20","0.07","0.20","0.13","0.07","0.20","0.20","0.13","0.13","0.20","0.00"],
	["0.20","0.33","0.27","0.27","0.07","0.60","0.40","0.13","0.27","0.07","0.13","0.33","0.27","0.07","0.20","0.27","0.20","0.13","0.20","0.13","0.00"],
	["0.20","0.27","0.27","0.40","0.00","0.40","0.60","0.13","0.27","0.07","0.07","0.33","0.13","0.07","0.20","0.27","0.20","0.07","0.13","0.13","0.00"],
	["0.27","0.13","0.27","0.20","0.07","0.13","0.13","0.67","0.13","0.00","0.00","0.13","0.07","0.07","0.13","0.27","0.13","0.13","0.07","0.07","0.00"],
	["0.13","0.27","0.33","0.20","0.07","0.27","0.27","0.13","0.80","0.07","0.07","0.20","0.13","0.20","0.13","0.20","0.13","0.13","0.40","0.07","0.00"],
	["0.20","0.07","0.07","0.07","0.20","0.07","0.07","0.00","0.07","0.53","0.40","0.07","0.33","0.27","0.07","0.13","0.20","0.07","0.20","0.47","0.00"],
	["0.20","0.13","0.07","0.00","0.20","0.13","0.07","0.00","0.07","0.40","0.53","0.13","0.40","0.27","0.07","0.13","0.20","0.13","0.20","0.33","0.00"],
	["0.20","0.40","0.27","0.20","0.07","0.33","0.33","0.13","0.20","0.07","0.13","0.60","0.20","0.07","0.20","0.27","0.20","0.07","0.13","0.13","0.00"],
	["0.20","0.20","0.13","0.07","0.20","0.27","0.13","0.07","0.13","0.33","0.40","0.20","0.60","0.27","0.13","0.20","0.20","0.20","0.20","0.33","0.00"],
	["0.13","0.07","0.07","0.07","0.13","0.07","0.07","0.07","0.20","0.27","0.27","0.07","0.27","0.67","0.00","0.13","0.13","0.33","0.47","0.20","0.00"],
	["0.20","0.13","0.13","0.20","0.07","0.20","0.20","0.13","0.13","0.07","0.07","0.20","0.13","0.00","0.73","0.20","0.20","0.00","0.07","0.13","0.00"],
	["0.33","0.20","0.33","0.27","0.20","0.27","0.27","0.27","0.20","0.13","0.13","0.27","0.20","0.13","0.20","0.53","0.33","0.07","0.13","0.13","0.00"],
	["0.27","0.20","0.27","0.20","0.20","0.20","0.20","0.13","0.13","0.20","0.20","0.20","0.20","0.13","0.20","0.33","0.60","0.13","0.13","0.27","0.00"],
	["0.07","0.07","0.00","0.00","0.13","0.13","0.07","0.13","0.13","0.07","0.13","0.07","0.20","0.33","0.00","0.07","0.13","1.00","0.40","0.07","0.00"],
	["0.13","0.13","0.13","0.07","0.13","0.20","0.13","0.07","0.40","0.20","0.20","0.13","0.20","0.47","0.07","0.13","0.13","0.40","0.73","0.20","0.00"],
	["0.27","0.07","0.07","0.07","0.20","0.13","0.13","0.07","0.07","0.47","0.33","0.13","0.33","0.20","0.13","0.13","0.27","0.07","0.20","0.53","0.00"],
	["0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00"],
	);
	$thisScore=$blosum62[$AA1][$AA2];
	return $thisScore;
}



