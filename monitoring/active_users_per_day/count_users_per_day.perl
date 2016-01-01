#!/opt/local/bin/perl

# Count the number of users transcribing each day

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

my $transcriptionsI = $db->get_collection( 'classifications' )->find();

my %Days;
while ( my $Transcription = $transcriptionsI->next ) {
    my $Date = $Transcription->{created_at};
        my $Key = sprintf "%04d-%02d-%02d",$Date->{local_c}->{year},$Date->{local_c}->{month},$Date->{local_c}->{day};
    unless(defined($Transcription->{user_id})) { next; }
	$Days{$Key}{$Transcription->{user_id}}++;
}

foreach my $Day (sort(keys(%Days))) {
	printf "%s %d\n",$Day,scalar(keys(%{$Days{$Day}}));
}
