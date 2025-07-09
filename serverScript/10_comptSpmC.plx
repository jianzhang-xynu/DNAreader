#! /usr/bin/perl

use List::Util qw/sum/;

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

	open READ,"$taskID/couplings/$count.csv";
	chomp(@array=<READ>);
	close READ;

	open CSVED54,"$taskID/couplings/$count.fd54";
	chomp(@csved54=<CSVED54>);
	close CSVED54;

	open CSVED80,"$taskID/couplings/$count.fd80";
	chomp(@csved80=<CSVED80>);
	close CSVED80;

	open WRITESMC54,">$taskID/couplings/$count.smc54";
	for($ct=0;$ct<@array;$ct++){
		@array1=split(/,/,@array[$ct]);
		@rank1 = sortArrayfun1(\@array1);$lenrank1=@rank1;
		for($cy=0;$cy<@array;$cy++){
			if(@csved54[$cy] eq "Y"){
				@array2=split(/,/,@array[$cy]);
				@rank2 = sortArrayfun2(\@array2);$lenrank2=@rank2;
				if($lenrank1==$lenrank2 && $lenrank1 > 0){
					$PCC=pearsonCC(\@rank1,\@rank2);
				}else{
					$PCC="NA";
				}
				my $currline=$cy+1;
				printf WRITESMC54 ("%4.3f,",$PCC);
			}
		}
		print WRITESMC54 "\n";
	}
	close WRITESMC54;

	open WRITESMC80,">$taskID/couplings/$count.smc80";
	for($ct=0;$ct<@array;$ct++){
		@array1=split(/,/,@array[$ct]);
		@rank1 = sortArrayfun1(\@array1);$lenrank1=@rank1;
		for($cy=0;$cy<@array;$cy++){
			if(@csved80[$cy] eq "Y"){
				@array2=split(/,/,@array[$cy]);
				@rank2 = sortArrayfun2(\@array2);$lenrank2=@rank2;
				if($lenrank1==$lenrank2 && $lenrank1 > 0){
					$PCC=pearsonCC(\@rank1,\@rank2);
				}else{
					$PCC="NA";
				}
				my $currline=$cy+1;
				printf WRITESMC80 ("%4.3f,",$PCC);
			}
		}
		print WRITESMC80 "\n";
	}
	close WRITESMC80;
}

#----------------------array1--------------------------------------------#
#------------------------------------------------------------------------#
sub sortArrayfun1{

	my $array1 = @_;
	my @newarray=();
    foreach(@array1){push(@newarray,$_);} #put array1 into a new vector

	#for($ck=0;$ck<@newarray;$ck++){print "inner    ".@newarray[$ck]."\n";}
	$vecLen=@newarray;

	@rank1=();
	@rank1[sort { $newarray[$a] <=> $newarray[$b] } 0 .. $#newarray] = 0 .. $#newarray;

	%hash1 = ();
	for($cn=0;$cn<$vecLen;$cn++){
		push @{$hash1{$newarray[$cn]}}, $rank1[$cn];
	}
	@hash1keys=keys %hash1;
	for($cn=0;$cn<@hash1keys;$cn++){
		$thishash1keys=@hash1keys[$cn];
		$sumthisRanks1=0;$countthisRanks1=0;$meanthisRanks1=0;
		for($cm=0;$cm<$vecLen;$cm++){
			if($newarray[$cm] == $thishash1keys){
			$sumthisRanks1=@rank1[$cm]+$sumthisRanks1;
			$countthisRanks1=$countthisRanks1+1;
			}
		}
		$meanthisRanks1=$sumthisRanks1/$countthisRanks1;
		for($cm=0;$cm<$vecLen;$cm++){
			if($newarray[$cm] == $thishash1keys){
			@rank1[$cm]=$meanthisRanks1;
			}
		}
	}

    return (@rank1);
}
#------------------------------------------------------------------------#
#----------------------array1--------------------------------------------#



#----------------------array2--------------------------------------------#
#------------------------------------------------------------------------#
sub sortArrayfun2{

	my $array2 = @_;
	my @newarray=();
    foreach(@array2){push(@newarray,$_);} #put array2 into a new vector

	#for($ck=0;$ck<@newarray;$ck++){print "next   ".@newarray[$ck]."\n";}
	$vecLen=@newarray;

	@rank2=();
	@rank2[sort { $newarray[$a] <=> $newarray[$b] } 0 .. $#newarray] = 0 .. $#newarray;

	%hash2 = ();
	for($cn=0;$cn<$vecLen;$cn++){
		push @{$hash2{$newarray[$cn]}}, $rank2[$cn];
	}
	@hash2keys=keys %hash2;
	for($cn=0;$cn<@hash2keys;$cn++){
		$thishash2keys=@hash2keys[$cn];
		$sumthisRanks2=0;$countthisRanks2=0;$meanthisRanks2=0;
		for($cm=0;$cm<$vecLen;$cm++){
			if($newarray[$cm] == $thishash2keys){
			$sumthisRanks2=@rank2[$cm]+$sumthisRanks2;
			$countthisRanks2=$countthisRanks2+1;
			}
		}
		$meanthisRanks2=$sumthisRanks2/$countthisRanks2;
		for($cm=0;$cm<$vecLen;$cm++){
			if($newarray[$cm] == $thishash2keys){
			@rank2[$cm]=$meanthisRanks2;
			}
		}
	}

    return (@rank2);
}
#------------------------------------------------------------------------#
#----------------------array2--------------------------------------------#



#-------------------------pearsonCC--------------------------------------#
#------------------------------------------------------------------------#
sub pearsonCC{
	(my $Xvector,my $Yvector)=@_;

	$fenzi=0;
	$fenmu=0;

	$lenVector=@$Xvector;
	#---fenziX------------
	my $sumXvector = sum @$Xvector;
	my $avgXvector = $sumXvector/$lenVector;
	@fenziPartX=();
	for($cn=0;$cn<$lenVector;$cn++){
		my $tempfenziPartX=@$Xvector[$cn]-$avgXvector;
		push(@fenziPartX,$tempfenziPartX);
	}
	#---fenziY------------
	my $sumYvector = sum @$Yvector;
	my $avgYvector = $sumYvector/$lenVector;
	@fenziPartY=();
	for($cn=0;$cn<$lenVector;$cn++){
		my $tempfenziPartY=@$Yvector[$cn]-$avgYvector;
		push(@fenziPartY,$tempfenziPartY);
	}
	#---fenziTogether------------
	@fenziTogether=();
	for($cn=0;$cn<$lenVector;$cn++){
		my $tempfenziTogether=@fenziPartX[$cn]*@fenziPartY[$cn];
		push(@fenziTogether,$tempfenziTogether);
	}
	$fenzi=sum @fenziTogether;
	#--------fenmuPartX------
	@fenmuPartX=();
	for($cn=0;$cn<$lenVector;$cn++){
		my $tempfenmuPartX=@fenziPartX[$cn]*@fenziPartX[$cn];
		push(@fenmuPartX,$tempfenmuPartX);
	}
	$sumfenmuPartX=sum @fenmuPartX;
	#--------fenmuPartX------
	@fenmuPartX=();
	for($cn=0;$cn<$lenVector;$cn++){
		my $tempfenmuPartX=@fenziPartX[$cn]*@fenziPartX[$cn];
		push(@fenmuPartX,$tempfenmuPartX);
	}
	$sumfenmuPartX=sum @fenmuPartX;
	#--------fenmuPartY------
	@fenmuPartY=();
	for($cn=0;$cn<$lenVector;$cn++){
		my $tempfenmuPartY=@fenziPartY[$cn]*@fenziPartY[$cn];
		push(@fenmuPartY,$tempfenmuPartY);
	}
	$sumfenmuPartY=sum @fenmuPartY;
	$fenmu=sqrt($sumfenmuPartX*$sumfenmuPartY);

	if($fenmu == 0){$PCC=0;}
	else{$PCC=$fenzi/$fenmu;}

	return $PCC;
}
#------------------------------------------------------------------------#
#-------------------------pearsonCC--------------------------------------#

