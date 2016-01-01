#!/opt/local/bin/perl

# Delete the existing oldWeather4 operational database and install another from backup files.

use strict;
use warnings;
use FindBin;
use Getopt::Long;
use MongoDB;
use MongoDB::OID;
use boolean;

my $Backup_dir;
GetOptions( "dir=s" => \$Backup_dir);
unless(defined($Backup_dir) && -d $Backup_dir) {
	die "No directory supplied";
}

# Drop the existing database
my $conn = MongoDB::Connection->new( query_timeout => -1 ) or die "No database connection";
my $db = $conn->get_database('whaletales-production')
  or die "OW4 production database not found";
my $Removed = $db->drop;

# Reload from backup
system("mongorestore \"$Backup_dir\"");

