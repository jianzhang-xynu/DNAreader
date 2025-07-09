#! /usr/bin/perl

$taskID=$ARGV[0];

$maxA=121;$maxR=265;$maxN=187;$maxD=187;$maxC=148;
$maxE=214;$maxQ=214;$maxG=97;$maxH=216;$maxI=195;
$maxL=191;$maxK=230;$maxM=203;$maxF=228;$maxP=154;
$maxS=143;$maxT=163;$maxW=264;$maxY=255;$maxV=165;

system "mkdir -p $taskID/RSA/";

opendir DIR,"$taskID/fastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;

for($cn=0;$cn<@file;$cn++){
	system "/home/userver/ASAquick/bin/ASAquick $taskID/fastas/$cn.txt";
	$folderName="asaq."."$cn".".txt";
	system "cp $folderName/asaq.pred $taskID/RSA/$cn.asa";
	system "rm -rf $folderName";
}

for($cn=0;$cn<@file;$cn++){
	open READ,"$taskID/RSA/$cn.asa";
	open WRITE,">$taskID/RSA/$cn.temprsa";
	while(defined($eachline = <READ>)){
		chomp($eachline);
		my @array = split(/\s+/,$eachline);
		if(@array[1] eq "A"){
			printf WRITE ("%4.3f\n",@array[2]/$maxA);
		}
		if(@array[1] eq "R"){
			printf WRITE ("%4.3f\n",@array[2]/$maxR);
		}
		if(@array[1] eq "N"){
			printf WRITE ("%4.3f\n",@array[2]/$maxN);
		}
		if(@array[1] eq "D"){
			printf WRITE ("%4.3f\n",@array[2]/$maxD);
		}
		if(@array[1] eq "C"){
			printf WRITE ("%4.3f\n",@array[2]/$maxC);
		}

		if(@array[1] eq "E"){
			printf WRITE ("%4.3f\n",@array[2]/$maxE);
		}
		if(@array[1] eq "Q"){
			printf WRITE ("%4.3f\n",@array[2]/$maxQ);
		}
		if(@array[1] eq "G"){
			printf WRITE ("%4.3f\n",@array[2]/$maxG);
		}
		if(@array[1] eq "H"){
			printf WRITE ("%4.3f\n",@array[2]/$maxH);
		}
		if(@array[1] eq "I"){
			printf WRITE ("%4.3f\n",@array[2]/$maxI);
		}

		if(@array[1] eq "L"){
			printf WRITE ("%4.3f\n",@array[2]/$maxL);
		}
		if(@array[1] eq "K"){
			printf WRITE ("%4.3f\n",@array[2]/$maxK);
		}
		if(@array[1] eq "M"){
			printf WRITE ("%4.3f\n",@array[2]/$maxM);
		}
		if(@array[1] eq "F"){
			printf WRITE ("%4.3f\n",@array[2]/$maxF);
		}
		if(@array[1] eq "P"){
			printf WRITE ("%4.3f\n",@array[2]/$maxP);
		}

		if(@array[1] eq "S"){
			printf WRITE ("%4.3f\n",@array[2]/$maxS);
		}
		if(@array[1] eq "T"){
			printf WRITE ("%4.3f\n",@array[2]/$maxT);
		}
		if(@array[1] eq "W"){
			printf WRITE ("%4.3f\n",@array[2]/$maxW);
		}
		if(@array[1] eq "Y"){
			printf WRITE ("%4.3f\n",@array[2]/$maxY);
		}
		if(@array[1] eq "V"){
			printf WRITE ("%4.3f\n",@array[2]/$maxV);
		}
	}
}


for($cn=0;$cn<@file;$cn++){
	open READ,"$taskID/RSA/$cn.temprsa";
	open WRITE,">$taskID/RSA/$cn.rsa";
	while(defined($eachline=<READ>)){
		chomp($eachline);
		if($eachline < 0){print WRITE "0.000\n";}
		elsif($eachline > 1){print WRITE "1.000\n";}
		else{print WRITE $eachline."\n";}
	}
	close WRITE;
	close READ;
}
