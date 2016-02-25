#!/opt/local/bin/perl

# Count the active and retired pages for each ship

use strict;
use warnings;
use MongoDB;
use MongoDB::OID;
use boolean;
use Getopt::Long;
use Data::Dumper;

# Open the database connection (default port, default server)
my $conn = MongoDB::Connection->new( query_timeout => -1 )
  or die "No database connection";

# Connect to the OldWeather3 database
my $db = $conn->get_database('whaletales-production')
  or die "OW4 database not found";

# Get all the groups (logbooks)
my $setI = $db->get_collection('groups')->find();

my %Sets;
while ( my $Set = $setI->next ) {

    my $Name = $Set->{name};

    my $finished = $Set->{stats}->{total_finished};
    my $pending  = $Set->{stats}->{total_pending};
    my $active1 =
      $Set->{stats}->{workflow_counts}->{'560466433937640006010000'}
      ->{active_subjects};
    my $total1 =
      $Set->{stats}->{workflow_counts}->{'560466433937640006010000'}
      ->{total_subjects};
    my $active2 =
      $Set->{stats}->{workflow_counts}->{'5604664339376400062c0000'}
      ->{active_subjects};
    my $total2 =
      $Set->{stats}->{workflow_counts}->{'5604664339376400062c0000'}
    ->{total_subjects};
    unless(defined($active1)) { $active1=0; }
    unless(defined($total1)) { $total1=1; }
    unless(defined($active2)) { $active2=0; }
    unless(defined($total2)) { $total2=1; }
    printf
"%20s: Stats %4d total, %4d retired (%3d%%); Marking %4d total, %4d retired (%3d%%); Transcription %4d total, %4d retired (%3d%%).\n",
      $Name, $finished + $pending, $finished,
      100 * $finished / ( $finished + $pending ),
      $total1, $total1 - $active1, 100 * ( $total1 - $active1 ) / $total1,
      $total2, $total2 - $active2, 100 * ( $total2 - $active2 ) / $total2;
}
