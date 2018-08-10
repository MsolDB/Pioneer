#!/usr/bin/perl
# use strict;

################################################################################################################
#
# CHANGE LOG
#
# 17/05/2017 - First draft: Check for .PROCESS_COMPLETE files in processing directory
#              If there are 2 files then automated processing has completed & we are
#              free to run the clean up scripts
#
################################################################################################################

my $file_count;
my $curDir = ".\\2 Processing";

my $batch1 = ".\\CLEANUP 1 - Return to Sender Log.cmd";
my $batch2 = ".\\CLEANUP 2 - Return to Client Files.cmd";
my $batch3 = ".\\CLEANUP 3 - Archive Job.cmd";

opendir(my $dh, $curDir) or die "opendir($curdir): $!";

while (my $de = readdir($dh)) {
  next if $de =~ /^\./ or $de !~ /PROCESS_COMPLETE/;
  $file_count++;
}

#Check if 2 .PROCESS_COMPLETE files exist. Start the clean up process if they do otherwise exit
if($file_count < 2){ 
#	die "\nProcess not yet complete!\n";
	exit;
}
else{ 
#	print "\nProcess Complete. $file_count files found. Clean up will commence in 3... 2.. 1.\n\n"; 

	system($batch1);	# Call clean up batch file 1
	sleep(20);			# Wait 20 seconds to give the batch file time to finish processing
	system($batch2);	# Call clean up batch file 2
	sleep(20);			# Wait 20 seconds to give the batch file time to finish processing
	system($batch3);	# Call clean up batch file 3
	sleep(20);			# Wait 20 seconds to give the batch file time to finish processing
}

closedir($dh);
