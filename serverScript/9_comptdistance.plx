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

	open CSV54,"$taskID/couplings/$cn.fd54" or die "csved error\n";
	chomp(@csv54=<CSV54>);
	close CSV54;
	$prolen=@csv54;

	open MTX4DIST,"$taskID/couplings/$cn.csv";
	chomp(@mtx4dist=<MTX4DIST>);
	close MTX4DIST;
	
	@templine=split(/,/,@mtx4dist[0]);
	$alnnum=@templine;
	
	open WRITE,">$taskID/couplings/$cn.dist54";
	for($ci=0;$ci<@csv54;$ci++){
		@tgtLine=split(/,/,@mtx4dist[$ci]); ## all residue, obtain its align scores

		for($outloop=0;$outloop<$prolen;$outloop++){ ##
			if(@csv54[$outloop] eq "Y"){
				@crrLine=split(/,/,@mtx4dist[$outloop]);
			
				$tempDist=0;$normDist=0;
				for($ck=0;$ck<$alnnum;$ck++){
					$tempDist=$tempDist+abs(@tgtLine[$ck]-@crrLine[$ck]);
				}
				if($ci == $outloop){
					$normDist=0.000;
				}elsif($alnnum == 0){
					$normDist=0.000;
				}else{
					$normDist=1-$tempDist/$alnnum;
				}
				
				my $currline=$outloop;
				printf WRITE ("%4.3f,",$normDist);
			}
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

	open MTX4DIST,"$taskID/couplings/$cn.csv";
	chomp(@mtx4dist=<MTX4DIST>);
	close MTX4DIST;
	
	@templine=split(/,/,@mtx4dist[0]);
	$alnnum=@templine;
	
	open WRITE,">$taskID/couplings/$cn.dist80";
	for($ci=0;$ci<@csv80;$ci++){
		@tgtLine=split(/,/,@mtx4dist[$ci]); ## all residue, obtain its align scores

		for($outloop=0;$outloop<$prolen;$outloop++){ ##
			if(@csv80[$outloop] eq "Y"){
				@crrLine=split(/,/,@mtx4dist[$outloop]);
			
				$tempDist=0;$normDist=0;
				for($ck=0;$ck<$alnnum;$ck++){
					$tempDist=$tempDist+abs(@tgtLine[$ck]-@crrLine[$ck]);
				}
				if($ci == $outloop){
					$normDist=0.000;
				}elsif($alnnum == 0){
					$normDist=0.000;
				}else{
					$normDist=1-$tempDist/$alnnum;
				}
				
				my $currline=$outloop;
				printf WRITE ("%4.3f,",$normDist);
			}
		}
		print WRITE "\n";
	}
	close WRITE;
}




