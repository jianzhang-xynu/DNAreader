#! /usr/bin/perl

$taskID=$ARGV[0];
system "mkdir -p $taskID/feasfolder/";

opendir DIR,"$taskID/fastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;

for($cn=0;$cn<@file;$cn++){

	open WINDCPLINS54,"$taskID/couplingsFeas/$cn.windcplins54";
	chomp(@windcplins54=<WINDCPLINS54>);
	close WINDCPLINS54;

	$prolen=@windcplins54;

	open WINDCPLINS80,"$taskID/couplingsFeas/$cn.windcplins80";
	chomp(@windcplins80=<WINDCPLINS80>);
	close WINDCPLINS80;

	open RSA,"$taskID/ECORSADisoFeas/$cn.rsawindfeas";
	chomp(@rsa=<RSA>);
	close RSA;

	open ECO,"$taskID/ECORSADisoFeas/$cn.ecowindfeas";
	chomp(@eco=<ECO>);
	close ECO;

	open DISO,"$taskID/ECORSADisoFeas/$cn.disowindfeas";
	chomp(@diso=<DISO>);
	close DISO;

	open PC,"$taskID/PCfeasfolder/$cn.txt";
	chomp(@pc=<PC>);
	close PC;

	open RAAC,"$taskID/RAACfeasfolder/$cn.txt";
	chomp(@raac=<RAAC>);
	close RAAC;

	open WRITE,">$taskID/feasfolder/$cn.txt";
	for($ck=0;$ck<$prolen;$ck++){
		print WRITE @windcplins54[$ck].@windcplins80[$ck].@rsa[$ck].",".@eco[$ck].",".@diso[$ck].",".@pc[$ck].",".@raac[$ck]."\n";
	}
	close WRITE;
}

