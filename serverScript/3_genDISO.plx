#! /usr/bin/perl

$taskID=$ARGV[0];

system "mkdir -p $taskID/DISO/";

opendir DIR,"$taskID/fastas" or die "Cannot open $dir:$!\n";
@file = ();
while(defined($file = readdir(DIR))){
    next if $file =~ /^\.\.?$/;# delete . and .. in the file
    if ($file =~ m/\./){$filename = $`;}
    push(@file,$filename);
}
closedir DIR;

for($cn=0;$cn<@file;$cn++){
	system "python3 /home/ubuntu/iupred3/iupred3.py $taskID/fastas/$cn.txt long > $taskID/DISO/$cn.long.out";
	system "python3 /home/ubuntu/iupred3/iupred3.py $taskID/fastas/$cn.txt short > $taskID/DISO/$cn.short.out";
}

for($cn=0;$cn<@file;$cn++){

	@longdiso=();
	@shortdiso=();

	open READLONGDISO,"$taskID/DISO/$cn.long.out";
	chomp(@longdisolines=<READLONGDISO>);
	close READLONGDISO;

	open READSHORTDISO,"$taskID/DISO/$cn.short.out";
	chomp(@shortdisolines=<READSHORTDISO>);
	close READSHORTDISOs;

	for($ck=12;$ck<@longdisolines;$ck++){
		my $thisline=@longdisolines[$ck];
		my @thisinfo=split(/\s+/,$thisline);
		push(@longdiso,@thisinfo[2]);
	}

	$prolen=@longdiso;

	for($ck=12;$ck<@shortdisolines;$ck++){
		my $thisline=@shortdisolines[$ck];
		my @thisinfo=split(/\s+/,$thisline);
		push(@shortdiso,@thisinfo[2]);
	}

	open WRITE,">$taskID/DISO/$cn.feas";
	for($cm=0;$cm<$prolen;$cm++){
		print WRITE @longdiso[$cm].",".@shortdiso[$cm]."\n";
	}
	close WRITE;

	open WRITE,">$taskID/DISO/$cn.longvalues";
	for($cm=0;$cm<$prolen;$cm++){
		print WRITE @longdiso[$cm]."\n";
	}
	close WRITE;

	open WRITE,">$taskID/DISO/$cn.shortvalues";
	for($cm=0;$cm<$prolen;$cm++){
		print WRITE @shortdiso[$cm]."\n";
	}
	close WRITE;

}

