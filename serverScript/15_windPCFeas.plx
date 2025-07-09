#! /usr/bin/perl

$taskID=$ARGV[0];

system "mkdir -p $taskID/PCFeas/";
system "mkdir -p $taskID/PCfeasfolder/";


opendir DIR,"$taskID/fastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;

for($cn=0;$cn<@file;$cn++){

	open TEMP,"$taskID/temppcfeas/$cn.txt";
	chomp(@temp=<TEMP>);
	close TEMP;

	$prolen=@temp;

	open WRITE,">$taskID/PCFeas/$cn.txt";
	print WRITE @temp[6]."\n";
	print WRITE @temp[5]."\n";
	print WRITE @temp[4]."\n";
	print WRITE @temp[3]."\n";
	print WRITE @temp[2]."\n";
	print WRITE @temp[1]."\n";
	print WRITE @temp[0]."\n";

	for($ck=0;$ck<@temp;$ck++){
		print WRITE @temp[$ck]."\n";
	}

	print WRITE @temp[$prolen-1]."\n";
	print WRITE @temp[$prolen-2]."\n";
	print WRITE @temp[$prolen-3]."\n";
	print WRITE @temp[$prolen-4]."\n";
	print WRITE @temp[$prolen-5]."\n";
	print WRITE @temp[$prolen-6]."\n";
	print WRITE @temp[$prolen-7]."\n";
	close WRITE;

}

for($cn=0;$cn<@file;$cn++){

	open PCFEAS,"$taskID/PCFeas/$cn.txt";
	chomp(@pcfeas=<PCFEAS>);
	close PCFEAS;

	$prowdlen=@pcfeas;

	open WRITEPC,">$taskID/PCfeasfolder/$cn.txt";
	for($ck=7;$ck<$prowdlen-7;$ck++){
		print WRITEPC @pcfeas[$ck-2].",".@pcfeas[$ck-1].",".@pcfeas[$ck].",".@pcfeas[$ck+1].",".@pcfeas[$ck+2]."\n";
	}
	close WRITEPC;
}



