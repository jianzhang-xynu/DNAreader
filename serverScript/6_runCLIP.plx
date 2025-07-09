#! /usr/bin/perl

$taskID=$ARGV[0];

system "mkdir -p $taskID/CLIPfolder/";

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

	$prolen=length(@array[1]);

	system "cp $taskID/fastas/$cn.txt ./";

	my $aln=$cn."-uniclust20-50.aln";
	my $output="$cn.output";

	my $CLIPdir="/home/userver/CLIP/bin";
	system "$CLIPdir/aln_ver2.sh $cn 50 0";
	system "$CLIPdir/custCo-evo $aln $output";

	system "mv $cn.hhr $taskID/CLIPfolder/";
	system "rm $cn.txt";

	$tmpname=$cn."-uniclust20";
	system "mv $tmpname.a3m $taskID/CLIPfolder/";
	system "mv $tmpname.aln $taskID/CLIPfolder/";
	system "mv $aln $taskID/CLIPfolder/";
	system "mv $output $taskID/CLIPfolder/";
}



