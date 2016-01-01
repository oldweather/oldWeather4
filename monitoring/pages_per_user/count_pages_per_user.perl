#!/opt/local/bin/perl

# Count the number of pages transcribed by each user

use strict;
use warnings;
use MongoDB;
use MongoDB::OID;
use boolean;

# Open the database connection (default port, default server)
my $conn = MongoDB::Connection->new( query_timeout => -1 )
  or die "No database connection";

# Connect to the OldWeather4 database
my $db = $conn->get_database('whaletales-production')
  or die "OW4 database not found";

my $transcriptionsI = $db->get_collection('classifications')->find();

my %Users;
while ( my $Transcription = $transcriptionsI->next ) {
    unless(defined($Transcription->{user_id})) { next; }
	$Users{$Transcription->{user_id}}++;
}

foreach my $User (sort {$Users{$b} <=> $Users{$a}}(keys(%Users))) {
	printf "%s %d\n",$User,$Users{$User};
}
