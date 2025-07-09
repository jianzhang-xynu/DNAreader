#! /usr/bin/perl

use Statistics::Descriptive;

$max=1.000;
$min=-0.15;

$taskID=$ARGV[0];

$hhblit_dir="/home/userver/hhblits/hhsuite-3.3.0";
$ENV{'HHLIB'}=$hhblit_dir;


system "mkdir -p $taskID/hhm/";
system "mkdir -p $taskID/eco/";


opendir DIR,"$taskID/fastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;


for($cn=0;$cn<@file;$cn++){

	system "$hhblit_dir/bin/hhblits -cpu 8 -i $taskID/fastas/$cn.txt -d $hhblit_dir/database/uniclust30_2018_08/uniclust30_2018_08 -n 1 -o $taskID/hhm/$cn.hhr -oa3m $taskID/hhm/$cn.oa3m";
	system "$hhblit_dir/bin/hhmake -i $taskID/hhm/$cn.oa3m -o $taskID/hhm/$cn.hhm";

}




for($cfile=0;$cfile<@file;$cfile++){

	open HHM,"$taskID/hhm/$cfile.hhm";
	@array=<HHM>;
	close HHM;

	$markline=0;
	for($cn=0;$cn<@array;$cn++){
		if(@array[$cn] =~ /#/){$markline=$cn;}
	}

	open MATRIX,">$taskID/eco/$cfile.matrix";
	for($ck=$markline+5;$ck<@array-2;){
		$thisline=@array[$ck];
		my @this = split(/\s+/,$thisline);
		print MATRIX @this[0]." ";
		for($ci=2;$ci<@this-1;$ci++){
			print MATRIX @this[$ci]." ";
		}
		print MATRIX "\n";
		$ck=$ck+3;
	}
	close MATRIX;
}


for($cnfile=0;$cnfile<@file;$cnfile++){
	open READMATRIX,"$taskID/eco/$cnfile.matrix" or die "read error\n";
	open WRITEFREQ,">$taskID/eco/$cnfile.freq";
	while(defined($eachline=<READMATRIX>)){
		chomp($eachline);
		@frequency=();
		my @array = split(/\s+/,$eachline);

		if($eachline=~ / 0 /){
			print WRITEFREQ @array[0]." *\n";
		}else{
			push(@frequency,@array[0]);
			for($cn=1;$cn<@array;$cn++){
				if(@array[$cn] eq "*"){
					$freq=0;
				}elsif(@array[$cn] eq "0"){
					$freq=1;
				}else{
					$freq=2**(@array[$cn]/(-1000));
				}
				push(@frequency,$freq);
			}
			print WRITEFREQ @frequency[0]." ";
			for($cm=1;$cm<@frequency;$cm++){
				printf WRITEFREQ ("%4.3f ",@frequency[$cm]);
			}
			print WRITEFREQ "\n";
		}
	}
	close WRITEFREQ;
	close READMATRIX;
}


for($countNum=0;$countNum<@file;$countNum++){
	open READFREQ,"$taskID/eco/$countNum.freq";
	open WRITEFR,">$taskID/eco/$countNum.1stFR";
	while(defined($eachline=<READFREQ>)){
		chomp($eachline);
		if($eachline =~ /\*/){
			print WRITEFR "S\n";
		}else{
			@array=split(/\s+/,$eachline);
			if(@array[0] eq "A"){$FR=0;$p0=0.078;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);		
			}
			if(@array[0] eq "R"){$FR=0;$p0=0.051;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "N"){$FR=0;$p0=0.041;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "D"){$FR=0;$p0=0.052;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "C"){$FR=0;$p0=0.024;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}

			if(@array[0] eq "Q"){$FR=0;$p0=0.034;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "E"){$FR=0;$p0=0.059;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "G"){$FR=0;$p0=0.083;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "H"){$FR=0;$p0=0.025;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "I"){$FR=0;$p0=0.062;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}


			if(@array[0] eq "L"){$FR=0;$p0=0.092;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "K"){$FR=0;$p0=0.056;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "M"){$FR=0;$p0=0.024;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "F"){$FR=0;$p0=0.044;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "P"){$FR=0;$p0=0.043;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}


			if(@array[0] eq "S"){$FR=0;$p0=0.059;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "T"){$FR=0;$p0=0.055;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "W"){$FR=0;$p0=0.014;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "Y"){$FR=0;$p0=0.034;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			if(@array[0] eq "V"){$FR=0;$p0=0.072;
				$fenzi=0;$fenmu=0;
				for($cm=1;$cm<@array;$cm++){
				$fenzi=$fenzi+(@array[$cm]*@array[$cm])/$p0;
				$fenmu=$fenmu+@array[$cm]/$p0;
				}
				$FR=log($fenzi)/log($fenmu);
			}
			printf WRITEFR ("%4.3f\n",$FR);
		}		
	}
	close WRITEFR;
	close READFREQ;
}



for($cn_num=0;$cn_num<@file;$cn_num++){
	open READ1FR,"$taskID/eco/$cn_num.1stFR";
	chomp(@orgiFR=<READ1FR>);
	close READ1FR;

	@thisECO=();
	for($cl=0;$cl<@orgiFR;$cl++){
		if(@orgiFR[$cl] eq "S"){
			;
		}else{
			push(@thisECO,@orgiFR[$cl]);
		}
	}



	my $statthisECO = Statistics::Descriptive::Full->new();
	$statthisECO->add_data(@thisECO);
	$MeanthisECO = $statthisECO->mean();

	open WRITE2FR,">$taskID/eco/$cn_num.2ndFR";
	for($co=0;$co<@orgiFR;$co++){
		if(@orgiFR[$co] eq "S"){
			printf WRITE2FR ("%4.3f\n",$MeanthisECO);
		}else{
			print WRITE2FR @orgiFR[$co]."\n";
		}
	}
	close WRITE2FR;
}


for($cn=0;$cn<@file;$cn++){
	open READ2FR,"$taskID/eco/$cn.2ndFR";
	open WRITEECO,">$taskID/eco/$cn.eco";
	while(defined($eachline=<READ2FR>)){
		chomp($eachline);

		my $thisECO=($eachline-$min)/($max-$min);
		if($thisECO > 1){$thisECO = 1;}
		if($thisECO < 0){$thisECO = 0;}

		printf WRITEECO ("%4.3f\n",$thisECO);
	}
	close WRITEECO;
	close READ2FR;
}
