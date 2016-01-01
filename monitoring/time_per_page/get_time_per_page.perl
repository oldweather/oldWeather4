#!/opt/local/bin/perl

# Get elapsed time for each classification

use strict;
use warnings;
use MongoDB;
use MongoDB::OID;
use boolean;
use Date::Calc 'Date_to_Time';

# Open the database connection (default port, default server)
my $conn = MongoDB::Connection->new( query_timeout => -1 )
  or die "No database connection";

# Connect to the oldWeather4 database
my $db = $conn->get_database('whaletales-production')
  or die "OW4 database not found";

my $transcriptionsI = $db->get_collection('classifications')->find();

while ( my $Transcription = $transcriptionsI->next ) {
    
    my $Date = $Transcription->{started_at};
    $Date =~ /(\d\d\d\d)\D(\d\d)\D(\d\d)\D(\d\d)\D(\d\d)\D(\d\d\.\d+)/ or die "Bad date $Date";
    my $TimeS = Date_to_Time($1,$2,$3,$4,$5,$6);
    $Date = $Transcription->{finished_at};
    $Date =~ /(\d\d\d\d)\D(\d\d)\D(\d\d)\D(\d\d)\D(\d\d)\D(\d\d\.\d+)/ or die "Bad date $Date";
    my $TimeF = Date_to_Time($1,$2,$3,$4,$5,$6);
    print $TimeF - $TimeS;
    print "\n";
}
