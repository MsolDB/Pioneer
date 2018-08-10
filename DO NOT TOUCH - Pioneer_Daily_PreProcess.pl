#!/usr/bin/perl
# use strict;

################################################################################################################
#
# CHANGE LOG
#
# 05/12/2016 - Ignore .pgp input file in the input directory
# 05/12/2016 - Added First Name / Last Name headings to report file
#
# 06/12/2016 - Remove creation of empty Stream C file since Sphere Letters are now a separate job
#
# 08/02/2017 - Save log files to a log file sub-directory
#            - Use File::Copy to move the original file out of the input data folder after processing
#             (this is for OL Connect)
#
################################################################################################################

sub get_letter_details{};
sub write_report{};

use Data::Dump qw(dump);
use File::Copy;

#Get job number from a file rather than have the user enter it manually
my $job_number;
my $job_number_file = "../DO THIS -- 1 Update Me - CURRENT JOB NUMBER.txt";
open(JOBNUMFILE, "< $job_number_file") or die "Can't open $job_number_file for reading: $!\n";
$job_number = <JOBNUMFILE>;
chomp($job_number);
print("\n\n$job_number\n\n");
close(JOBNUMFILE);

my $infile, $file, $outfile_stream_A, $outfile_stream_B, $outfile_stream_C, $daily_letter_report, $log_file;
my $line;
my $stream;
my @fields;

my $letter_name;
my ($PIFZ_Count,$CBPLL_Count,$DDDNZ_Count,$SFLZ_Count,$PADVZ_Count,$DISC_Count,$S88_Count,$BALPZ_Count,$PAZ_Count,$NOAZ_Count,$NOAFLX_Count,$CBCCL_Count)=0;
my ($stream_A_count,$RPE_count,$stream_C_count)=0;
my ($num_pages,$mailpack_weight, $average_weight,$letter_count,$total_pages)=0;

# Input file format:  DEBTOR_yyyymmddssss.txt

my $dir = "..\\1 Input Files";
opendir(BIN, $dir) or die "Can't open $dir: $!";
while( $file = readdir BIN) {

	next if $file =~ /^\.\.?$/;     # skip . and ..

	next if $file !~ /(DEBTOR_)(.{12})\.txt$/;

    print "$file\n" if -T "$dir/$file";

	$infile = $dir."\\".$file;
	open(INFILE, "< $infile") or die "Can't open $infile for reading: $!\n";

	$outfile_stream_A = ">".$infile; 
	$outfile_stream_A =~ s/1 Input Files/2 Processing/ig; 
	$outfile_stream_A =~ s/DEBTOR_/$job_number - DEBTOR_/ig; 

# No longer need the extensive file naming since we only have a single stream	
#	$outfile_stream_A =~ s/\.txt//ig; 
#	$outfile_stream_A =~ s/_/ - /ig; 
#	$outfile_stream_A .= " - A - No RPE\.txt";
	open(OUTFILE_STREAM_A, "$outfile_stream_A") || die "cannot open $outfile_stream_A: $!";

#No stream B anymore
#	$outfile_stream_B = $outfile_stream_A; 
#	$outfile_stream_B =~ s/ - A - No RPE/ - B - With RPE/ig; 
#	open(OUTFILE_STREAM_B, "$outfile_stream_B") || die "cannot open $outfile_stream_B: $!";

	while (<INFILE>) {

		$line = $_;
	
		chomp;														# remove newline character

		$letter_count++;

		&get_letter_details();
		
		#Keep the FileID as stream A. It's harmless (everything is now stream A) and save having to change the field layout downstream
		if ( $stream eq "A" ) {
			$stream_A_count++;
			print OUTFILE_STREAM_A "A\t$_\n";
		}
		elsif ( $stream eq "B" ) {
			$stream_B_count++;
			print OUTFILE_STREAM_B "B\t$_\n";
			die "\n\n** Error: Stream B entered - check files - there should only be stream A **\n\n";
		}
		elsif ( $stream eq "C" ) {								# Sphere letters are now a separate job so they should not appear in these files at all
			die "\n\n** Error: Sphere Letters found in Pioneer file **\n\n";
		}
		else{
			die "\n\n** Error: Could not determine stream $stream **\n\n";
		}
	}
	write_report();

	close(INFILE);
	close(OUTFILE_STREAM_A);
#	close(OUTFILE_STREAM_B);

	print "\n\n$file\n\n";
	move("..\\1 Input Files\\$file","..\\2 Processing\\") or die "Could not move the input file to the backup directory: $!";
}

sub get_letter_details{
		@fields = split(/\t/, $_);								#split record line in to seperate fields
		my $n = 0;

		$letter_name = $fields[48];

		print "\n\n$letter_name\n\n\n\n";

		if($letter_name eq "PIFZ"){
			$PIFZ_Count++;
			$stream = "A";
			$num_pages = 1;
			$total_pages += $num_pages;
			$mailpack_weight = 12;
		}elsif($letter_name eq "CBPLL"){
			$CBPLL_Count++;
			$stream = "A";
			$num_pages = 1;
			$total_pages += $num_pages;
			$mailpack_weight = 12;
		}elsif($letter_name eq "DDDNZ"){
			$DDDNZ_Count++;
			$stream = "A";
			$num_pages = 1;
			$total_pages += $num_pages;
			$mailpack_weight = 12;
		}elsif($letter_name eq "SFLZ"){
			$SFLZ_Count++;
			$stream = "A";
			$num_pages = 2;
			$total_pages += $num_pages;
			$mailpack_weight = 18;
		}elsif($letter_name eq "PADVZ"){
			$PADVZ_Count++;
			$stream = "A";
			$num_pages = 2;
			$total_pages += $num_pages;
			$mailpack_weight = 18;
		}elsif($letter_name eq "DISC"){
			$DISC_Count++;
			$stream = "A";
			$num_pages = 4;
			$total_pages += $num_pages;
			$mailpack_weight = 30;
		}elsif($letter_name eq "S88"){
			$S88_Count++;
			$stream = "A";
			$num_pages = 4;
			$total_pages += $num_pages;
			$mailpack_weight = 30;
		}elsif($letter_name eq "BALPZ"){
			$BALPZ_Count++;
			$RPE_count++;
			$stream = "A";
			$num_pages = 4;
			$total_pages += $num_pages;
			$mailpack_weight = 34;
		}elsif($letter_name eq "PAZ"){
			$PAZ_Count++;
			$stream = "A";
			$RPE_count++;
			$num_pages = 4;
			$total_pages += $num_pages;
			$mailpack_weight = 34;
		}elsif($letter_name eq "NOAZ"){
			$NOAZ_Count++;
			$stream = "A";
			$RPE_count++;
			$num_pages = 6;
			$total_pages += $num_pages;
			$mailpack_weight = 46;
		}elsif($letter_name eq "NOAFLX"){
			$NOAFLX_Count++;
			$RPE_count++;
			$stream = "A";
			$num_pages = 6;
			$total_pages += $num_pages;
			$mailpack_weight = 46;
		}elsif($letter_name eq "CBCCL"){
			$CBCCL_Count++;
			$stream = "C";
			$num_pages = 1;
			$mailpack_weight = 16;
		}else{
			die "\n\ncannot determine letter type: $letter_name\n\n";
		}

		$average_weight += $mailpack_weight;
}

sub write_report{

	my $rep_date = localtime();

	$average_weight = $average_weight / $letter_count;

	$daily_letter_report = ">..\\2 Processing\\Pioneer Daily Letter Report.csv";

	open(REPFILE, "$daily_letter_report") ||
		die "cannot open $daily_letter_report: $!";

	print REPFILE "File Name:,".$file."\n";
	print REPFILE "Date:,".$rep_date."\n";

	print REPFILE "\n";

	print REPFILE "Letter Name,Number of Letters\n";
	print REPFILE "PIFZ,"  .$PIFZ_Count."\n";
	print REPFILE "CBPLL," .$CBPLL_Count."\n";
	print REPFILE "DDDNZ," .$DDDNZ_Count."\n";
	print REPFILE "SFLZ,"  .$SFLZ_Count."\n";
	print REPFILE "PADVZ," .$PADVZ_Count."\n";
	print REPFILE "DISC,"  .$DISC_Count."\n";
	print REPFILE "S88,"   .$S88_Count."\n";

	print REPFILE "BALPZ," .$BALPZ_Count."\n";
	print REPFILE "PAZ,"   .$PAZ_Count."\n";
	print REPFILE "NOAZ,"  .$NOAZ_Count."\n";
	print REPFILE "NOAFLX,".$NOAFLX_Count."\n";

#	print REPFILE "Stream A Total,".$stream_A_count."\n\n";
#	print REPFILE "Stream B Total,".$stream_B_count."\n\n";

	print REPFILE "\nTotal Letters:,".$letter_count."\n\n";


	my $plain_count = $total_pages-$letter_count;
	print REPFILE "Total Letterhead:,".$letter_count."\n";
	print REPFILE "Total Plain A4/80:,".$plain_count."\n";
	print REPFILE "Total Pioneer DLX:,".$letter_count."\n";
	print REPFILE "Total Pioneer RPE:,".$RPE_count."\n\n";

	printf (REPFILE "Average Mailpack Weight:,%.0fg\n",$average_weight);

#	print REPFILE "\n\nStream A,Name 1\n";
#	print REPFILE ",Name 2\n\n";
#	print REPFILE "Stream B,Name 1\n";
#	print REPFILE ",Name 2\n";

	close REPFILE;

#Write log file
	$log_file = ">>..\\7 Log Files\\Pioneer Daily Log File.csv";
	open(REPFILE, "$log_file") ||
		die "cannot open $log_file: $!";

	print REPFILE "\n$job_number,$rep_date,$PIFZ_Count,$CBPLL_Count,$DDDNZ_Count,$SFLZ_Count,$PADVZ_Count,$DISC_Count,$S88_Count,$BALPZ_Count,$PAZ_Count,$NOAZ_Count,$NOAFLX_Count,$stream_A_count,0,$letter_count,$letter_count,$plain_count,$letter_count,$RPE_count";

	close REPFILE;
}
