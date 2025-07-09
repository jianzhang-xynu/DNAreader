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

$thres54=0.54;
$thres80=0.80;

for($cn=0;$cn<@file;$cn++){

	open ECO,"$taskID/eco/$cn.eco";
	chomp(@eco=<ECO>);
	close ECO;
	
	open WRITEFD54,">$taskID/couplings/$cn.fd54";
	for($ca=0;$ca<@eco;$ca++){
		if(@eco[$ca] >= $thres54){
			print WRITEFD54 "Y\n";
		}else{
			print WRITEFD54 "N\n";
		}
	}
	close WRITEFD54;

	open WRITEFD80,">$taskID/couplings/$cn.fd80";
	for($cb=0;$cb<@eco;$cb++){
		if(@eco[$cb] >= $thres80){
			print WRITEFD80 "Y\n";
		}else{
			print WRITEFD80 "N\n";
		}
	}
	close WRITEFD80;

	open WRITEPOS54,">$taskID/couplings/$cn.posi54";
	for($cc=0;$cc<@eco;$cc++){
		$markline=$cc;
		if(@eco[$cc] >= $thres54){
			print WRITEPOS54 $markline."\n";
		}
	}
	close WRITEPOS54;

	open WRITEPOS80,">$taskID/couplings/$cn.posi80";
	for($cc=0;$cc<@eco;$cc++){
		$markline=$cc;
		if(@eco[$cc] >= $thres80){
			print WRITEPOS80 $markline."\n";
		}
	}
	close WRITEPOS80;
}






