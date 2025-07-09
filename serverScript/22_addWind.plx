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

for($cn=0;$cn<@file;$cn++){
	open READ,"$taskID/DISO/$cn.shortvalues";
	chomp(@array=<READ>);
	close READ;

	$prolen=@array;

	open WRITE,">$taskID/step2feas/$cn.addshort";
	print WRITE @array[16]."\n";
	print WRITE @array[15]."\n";
	print WRITE @array[14]."\n";
	print WRITE @array[13]."\n";
	print WRITE @array[12]."\n";
	print WRITE @array[11]."\n";
	print WRITE @array[10]."\n";
	print WRITE @array[9]."\n";
	print WRITE @array[8]."\n";
	print WRITE @array[7]."\n";
	print WRITE @array[6]."\n";
	print WRITE @array[5]."\n";
	print WRITE @array[4]."\n";
	print WRITE @array[3]."\n";
	print WRITE @array[2]."\n";
	print WRITE @array[1]."\n";
	print WRITE @array[0]."\n";
	for($ck=0;$ck<$prolen;$ck++){
		print WRITE @array[$ck]."\n";
	}
	print WRITE @array[$prolen-1]."\n";
	print WRITE @array[$prolen-2]."\n";
	print WRITE @array[$prolen-3]."\n";
	print WRITE @array[$prolen-4]."\n";
	print WRITE @array[$prolen-5]."\n";
	print WRITE @array[$prolen-6]."\n";
	print WRITE @array[$prolen-7]."\n";
	print WRITE @array[$prolen-8]."\n";
	print WRITE @array[$prolen-9]."\n";
	print WRITE @array[$prolen-10]."\n";
	print WRITE @array[$prolen-11]."\n";
	print WRITE @array[$prolen-12]."\n";
	print WRITE @array[$prolen-13]."\n";
	print WRITE @array[$prolen-14]."\n";
	print WRITE @array[$prolen-15]."\n";
	print WRITE @array[$prolen-16]."\n";
	print WRITE @array[$prolen-17]."\n";
	close WRITE;
}


for($cn=0;$cn<@file;$cn++){
	open READ,"$taskID/DISO/$cn.longvalues";
	chomp(@array=<READ>);
	close READ;

	$prolen=@array;

	open WRITE,">$taskID/step2feas/$cn.addlong";
	print WRITE @array[16]."\n";
	print WRITE @array[15]."\n";
	print WRITE @array[14]."\n";
	print WRITE @array[13]."\n";
	print WRITE @array[12]."\n";
	print WRITE @array[11]."\n";
	print WRITE @array[10]."\n";
	print WRITE @array[9]."\n";
	print WRITE @array[8]."\n";
	print WRITE @array[7]."\n";
	print WRITE @array[6]."\n";
	print WRITE @array[5]."\n";
	print WRITE @array[4]."\n";
	print WRITE @array[3]."\n";
	print WRITE @array[2]."\n";
	print WRITE @array[1]."\n";
	print WRITE @array[0]."\n";
	for($ck=0;$ck<$prolen;$ck++){
		print WRITE @array[$ck]."\n";
	}
	print WRITE @array[$prolen-1]."\n";
	print WRITE @array[$prolen-2]."\n";
	print WRITE @array[$prolen-3]."\n";
	print WRITE @array[$prolen-4]."\n";
	print WRITE @array[$prolen-5]."\n";
	print WRITE @array[$prolen-6]."\n";
	print WRITE @array[$prolen-7]."\n";
	print WRITE @array[$prolen-8]."\n";
	print WRITE @array[$prolen-9]."\n";
	print WRITE @array[$prolen-10]."\n";
	print WRITE @array[$prolen-11]."\n";
	print WRITE @array[$prolen-12]."\n";
	print WRITE @array[$prolen-13]."\n";
	print WRITE @array[$prolen-14]."\n";
	print WRITE @array[$prolen-15]."\n";
	print WRITE @array[$prolen-16]."\n";
	print WRITE @array[$prolen-17]."\n";
	close WRITE;
}



