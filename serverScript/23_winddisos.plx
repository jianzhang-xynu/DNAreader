#! /usr/bin/perl

use Statistics::Descriptive;

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
	open DISOVALUE,"$taskID/step2feas/$cn.addshort";
	chomp(@disoValue=<DISOVALUE>);
	close DISOVALUE;

	$disoValuelen=@disoValue;
	
	open WRITE,">$taskID/step2feas/$cn.shortfeas";
	for($count=17;$count<$disoValuelen-17;$count++){

		#-----------------------------window 5
		$Meandiso5=0;$StdDevdiso5=0;@disoValue5=();
		for($cm=$count-2;$cm<$count+2;$cm++){
			push(@disoValue5,@disoValue[$cm]);
		}

		my $countdiso5=@disoValue5;
		my $statdiso5 = Statistics::Descriptive::Full->new();
		$statdiso5->add_data(@disoValue5);
		$Meandiso5 = $statdiso5->mean();
		$StdDevdiso5=$statdiso5->standard_deviation();
		#-----------------------------window 5

		#-----------------------------window 9
		$Meandiso9=0;$StdDevdiso9=0;@disoValue9=();
		for($cm=$count-4;$cm<$count+4;$cm++){
			push(@disoValue9,@disoValue[$cm]);
		}

		my $countdiso9=@disoValue9;
		my $statdiso9 = Statistics::Descriptive::Full->new();
		$statdiso9->add_data(@disoValue9);
		$Meandiso9 = $statdiso9->mean();
		$StdDevdiso9=$statdiso9->standard_deviation();
		#-----------------------------window 9

		#-----------------------------window 13
		$Meandiso13=0;$StdDevdiso13=0;
		@disoValue13=();
		for($cm=$count-6;$cm<$count+6;$cm++){
			push(@disoValue13,@disoValue[$cm]);
		}

		my $countdiso13=@disoValue13;
		my $statdiso13 = Statistics::Descriptive::Full->new();
		$statdiso13->add_data(@disoValue13);
		$Meandiso13 = $statdiso13->mean();
		$StdDevdiso13=$statdiso13->standard_deviation();
		#-----------------------------window 13

		printf WRITE ("%4.3f ",@disoValue[$count-4]);
		printf WRITE ("%4.3f ",@disoValue[$count-3]);
		printf WRITE ("%4.3f ",@disoValue[$count-2]);
		printf WRITE ("%4.3f ",@disoValue[$count-1]);
		printf WRITE ("%4.3f ",@disoValue[$count]);
		printf WRITE ("%4.3f ",@disoValue[$count+1]);
		printf WRITE ("%4.3f ",@disoValue[$count+2]);
		printf WRITE ("%4.3f ",@disoValue[$count+3]);
		printf WRITE ("%4.3f ",@disoValue[$count+4]);
		printf WRITE ("%4.3f %4.3f ",$Meandiso5, $StdDevdiso5);
		printf WRITE ("%4.3f %4.3f ",$Meandiso9, $StdDevdiso9);
		printf WRITE ("%4.3f %4.3f\n",$Meandiso13, $StdDevdiso13);
	}
	close WRITE;
}


for($cn=0;$cn<@file;$cn++){
	open DISOVALUE,"$taskID/step2feas/$cn.addlong";
	chomp(@disoValue=<DISOVALUE>);
	close DISOVALUE;

	$disoValuelen=@disoValue;
	
	open WRITE,">$taskID/step2feas/$cn.longfeas";
	for($count=17;$count<$disoValuelen-17;$count++){

		#-----------------------------window 5
		$Meandiso5=0;$StdDevdiso5=0;@disoValue5=();
		for($cm=$count-2;$cm<$count+2;$cm++){
			push(@disoValue5,@disoValue[$cm]);
		}

		my $countdiso5=@disoValue5;
		my $statdiso5 = Statistics::Descriptive::Full->new();
		$statdiso5->add_data(@disoValue5);
		$Meandiso5 = $statdiso5->mean();
		$StdDevdiso5=$statdiso5->standard_deviation();
		#-----------------------------window 5

		#-----------------------------window 9
		$Meandiso9=0;$StdDevdiso9=0;@disoValue9=();
		for($cm=$count-4;$cm<$count+4;$cm++){
			push(@disoValue9,@disoValue[$cm]);
		}

		my $countdiso9=@disoValue9;
		my $statdiso9 = Statistics::Descriptive::Full->new();
		$statdiso9->add_data(@disoValue9);
		$Meandiso9 = $statdiso9->mean();
		$StdDevdiso9=$statdiso9->standard_deviation();
		#-----------------------------window 9

		#-----------------------------window 13
		$Meandiso13=0;$StdDevdiso13=0;
		@disoValue13=();
		for($cm=$count-6;$cm<$count+6;$cm++){
			push(@disoValue13,@disoValue[$cm]);
		}

		my $countdiso13=@disoValue13;
		my $statdiso13 = Statistics::Descriptive::Full->new();
		$statdiso13->add_data(@disoValue13);
		$Meandiso13 = $statdiso13->mean();
		$StdDevdiso13=$statdiso13->standard_deviation();
		#-----------------------------window 13

		printf WRITE ("%4.3f ",@disoValue[$count-4]);
		printf WRITE ("%4.3f ",@disoValue[$count-3]);
		printf WRITE ("%4.3f ",@disoValue[$count-2]);
		printf WRITE ("%4.3f ",@disoValue[$count-1]);
		printf WRITE ("%4.3f ",@disoValue[$count]);
		printf WRITE ("%4.3f ",@disoValue[$count+1]);
		printf WRITE ("%4.3f ",@disoValue[$count+2]);
		printf WRITE ("%4.3f ",@disoValue[$count+3]);
		printf WRITE ("%4.3f ",@disoValue[$count+4]);
		printf WRITE ("%4.3f %4.3f ",$Meandiso5, $StdDevdiso5);
		printf WRITE ("%4.3f %4.3f ",$Meandiso9, $StdDevdiso9);
		printf WRITE ("%4.3f %4.3f\n",$Meandiso13, $StdDevdiso13);
	}
	close WRITE;
}
