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

# Get all the subject_sets (logbooks)
my $setI = $db->get_collection('subject_sets')->find();

my %Sets;
while ( my $Set = $setI->next ) {

    my $Name = $Set->{meta_data}->{set_key};

    my $state = $Set->{state};
    my $active1 =
      $Set->{counts}->{'560466433937640006010000'}->{active_subjects};
    my $total1 =
      $Set->{counts}->{'560466433937640006010000'}->{total_subjects};
    my $complete1 =
      $Set->{counts}->{'560466433937640006010000'}->{complete_subjects};
    my $active2 =
	$Set->{counts}->{'5604664339376400062c0000'}->{active_subjects};
    unless(defined($complete1)) { $complete1=0; }
    unless(defined($active1)) { $active1=0; }
    unless(defined($total1)) { $total1=1; }
    unless(defined($active2)) { $active2=0; }
    printf
"%20s: %s. %4d total, %4d retired (%3d%%) %4d active (%4d%%). Transcription %4d\n",
      $Name, $state, $total1, $complete1,
      100 * $complete1 / $total1,
      $active1, 100 * $active1 / $total1,
      $active2;
}
