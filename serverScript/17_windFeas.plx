#! /usr/bin/perl

$taskID=$ARGV[0];
system "mkdir -p $taskID/ECORSADisoFeas/";

opendir DIR,"$taskID/fastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;

for($cn=0;$cn<@file;$cn++){

	open ECO,"$taskID/eco/$cn.eco";
	chomp(@eco=<ECO>);
	close ECO;

	$prolen=@eco;

	open WRITE,">$taskID/ECORSADisoFeas/$cn.addWdeco";
	print WRITE @eco[6]."\n";
	print WRITE @eco[5]."\n";
	print WRITE @eco[4]."\n";
	print WRITE @eco[3]."\n";
	print WRITE @eco[2]."\n";
	print WRITE @eco[1]."\n";
	print WRITE @eco[0]."\n";

	for($ck=0;$ck<@eco;$ck++){
		print WRITE @eco[$ck]."\n";
	}

	print WRITE @eco[$prolen-1]."\n";
	print WRITE @eco[$prolen-2]."\n";
	print WRITE @eco[$prolen-3]."\n";
	print WRITE @eco[$prolen-4]."\n";
	print WRITE @eco[$prolen-5]."\n";
	print WRITE @eco[$prolen-6]."\n";
	print WRITE @eco[$prolen-7]."\n";
	close WRITE;

	open RSA,"$taskID/RSA/$cn.rsa";
	chomp(@rsa=<RSA>);
	close RSA;

	open WRITE,">$taskID/ECORSADisoFeas/$cn.addWdrsa";
	print WRITE @rsa[6]."\n";
	print WRITE @rsa[5]."\n";
	print WRITE @rsa[4]."\n";
	print WRITE @rsa[3]."\n";
	print WRITE @rsa[2]."\n";
	print WRITE @rsa[1]."\n";
	print WRITE @rsa[0]."\n";

	for($ck=0;$ck<@rsa;$ck++){
		print WRITE @rsa[$ck]."\n";
	}

	print WRITE @rsa[$prolen-1]."\n";
	print WRITE @rsa[$prolen-2]."\n";
	print WRITE @rsa[$prolen-3]."\n";
	print WRITE @rsa[$prolen-4]."\n";
	print WRITE @rsa[$prolen-5]."\n";
	print WRITE @rsa[$prolen-6]."\n";
	print WRITE @rsa[$prolen-7]."\n";
	close WRITE;

	open DISO,"$taskID/DISO/$cn.feas";
	chomp(@diso=<DISO>);
	close DISO;

	open WRITE,">$taskID/ECORSADisoFeas/$cn.addWddiso";
	print WRITE @diso[6]."\n";
	print WRITE @diso[5]."\n";
	print WRITE @diso[4]."\n";
	print WRITE @diso[3]."\n";
	print WRITE @diso[2]."\n";
	print WRITE @diso[1]."\n";
	print WRITE @diso[0]."\n";

	for($ck=0;$ck<@diso;$ck++){
		print WRITE @diso[$ck]."\n";
	}

	print WRITE @diso[$prolen-1]."\n";
	print WRITE @diso[$prolen-2]."\n";
	print WRITE @diso[$prolen-3]."\n";
	print WRITE @diso[$prolen-4]."\n";
	print WRITE @diso[$prolen-5]."\n";
	print WRITE @diso[$prolen-6]."\n";
	print WRITE @diso[$prolen-7]."\n";
	close WRITE;

}


for($cn=0;$cn<@file;$cn++){

	open READECO,"$taskID/ECORSADisoFeas/$cn.addWdeco";
	chomp(@windeco=<READECO>);
	close READECO;

	$prowdlen=@windeco;

	open WRITEECO,">$taskID/ECORSADisoFeas/$cn.ecowindfeas";
	for($ck=7;$ck<$prowdlen-7;$ck++){
		print WRITEECO @windeco[$ck-2].",".@windeco[$ck-1].",".@windeco[$ck].",".@windeco[$ck+1].",".@windeco[$ck+2]."\n";
	}
	close WRITEECO;


	open READRSA,"$taskID/ECORSADisoFeas/$cn.addWdrsa";
	chomp(@windrsa=<READRSA>);
	close READRSA;

	open WRITERSA,">$taskID/ECORSADisoFeas/$cn.rsawindfeas";
	for($ck=7;$ck<$prowdlen-7;$ck++){
		print WRITERSA @windrsa[$ck-2].",".@windrsa[$ck-1].",".@windrsa[$ck].",".@windrsa[$ck+1].",".@windrsa[$ck+2]."\n";
	}
	close WRITERSA;


	open READDISO,"$taskID/ECORSADisoFeas/$cn.addWddiso";
	chomp(@winddiso=<READDISO>);
	close READDISO;

	open WRITEDISO,">$taskID/ECORSADisoFeas/$cn.disowindfeas";
	for($ck=7;$ck<$prowdlen-7;$ck++){
		print WRITEDISO @winddiso[$ck-2].",".@winddiso[$ck-1].",".@winddiso[$ck].",".@winddiso[$ck+1].",".@winddiso[$ck+2]."\n";
	}
	close WRITEDISO;
}



