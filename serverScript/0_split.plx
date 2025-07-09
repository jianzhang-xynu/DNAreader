#! /usr/bin/perl

$taskID=$ARGV[0];

print $taskID."\n";
system "mkdir -p $taskID/orgifastas/";
system "mkdir -p $taskID/fastas/";

open READ,"$taskID/$taskID.txt" or die "read error\n";
open NAME,">$taskID/name.txt";

$flag=-1;
while($eachline=<READ>){
	chomp($eachline);
	if($eachline =~ /^>/){
		$flag=$flag+1;
		print NAME $eachline."\n";
		open FASTA,">$taskID/orgifastas/$flag.txt";
		print FASTA $eachline."\n";
		close FASTA;
	}else{
		open FASTA,">>$taskID/orgifastas/$flag.txt";
		print FASTA $eachline."\n";
		close FASTA;
	}
}
close READ;
close NAME;


opendir DIR,"$taskID/orgifastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;


for($cn=0;$cn<@file;$cn++){

	open FASTA,"$taskID/orgifastas/$cn.txt";
	chomp(@array=<FASTA>);
	close FASTA;

	@callen=split(//,@array[1]);
	$length=0;$templen=0;
	for($temp=0;$temp<@callen;$temp++){
		if(@callen[$temp] =~ /[A-Z]/){$templen++;}
	}
	$length=$templen;

	$proID=@array[0];
	@AA=split(//,@array[1]);
	
	open WRITE,">$taskID/fastas/$cn.txt";
	print WRITE $proID."\n";
	for($cm=0;$cm<$length;$cm++){
		if(@AA[$cm] =~ /B|J|O|U|X|Z/){
			print WRITE "C";
		}else{
			print WRITE @AA[$cm];
		}
	}
	print WRITE "\n";
	close WRITE;
}
