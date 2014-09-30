#perl

use strict;
use warnings;

use Cwd;
use Template;
use File::Basename;
use File::Path;
use File::Spec;
use Getopt::Long;
use FindBin qw($Bin);

my $vars;
$vars->{startdate} = "2014-02-15";
$vars->{branch}    = "master";
$vars->{title}     = "AHK-EDE";

my $outfile = File::Spec->rel2abs( ".\\ChangeLog.md" );
my $file    = "";

GetOptions(
  'startdate=s' => \$vars->{startdate},
  'branch=s'    => \$vars->{branch},
  'out=s'       => \$outfile,
  'f=s'         => \$file
);

$outfile = File::Spec->rel2abs($outfile);
File::Path::make_path( dirname($outfile) );

if ( $file ne '' ) {
  $vars->{title} = $file;
  $file = "-- " . $file;
}
else {
  $file = "-- " . $file;
}

# Ermittle alle Commithashes nach einem bestimmten Zeitpunkt
my $cmd =
    "git log --after="
  . $vars->{startdate}
  . " --simplify-merges --full-history --first-parent --pretty=format:%H "
  . $vars->{branch} . " "
  . $file;
my $output = `$cmd`;
my @commits = split /\n/, $output;

# Jetzt hole fuer alle ermittelten Commit-Hashes die entsprechenden Infos
my $data;

my $cnt = 0;
foreach my $curr_hash (@commits) {
  undef $data;
  $cmd = "git log -1 --pretty=format:[[[%an]]][[[%ae]]][[[%ad]]][[[%s]]][[[%b]]] " . $curr_hash;
  print $cmd. "\n";
  my $output = `$cmd`;
  $output =~ m{\[\[\[(.*?)\]\]\]\[\[\[(.*?)\]\]\]\[\[\[(.*?)\]\]\]\[\[\[(.*?)\]\]\]\[\[\[([\w\W]*?)\]\]\]};
  $data->{hash}         = $curr_hash;
  $data->{author_name}  = $1;
  $data->{author_email} = $2;
  $data->{date}         = $3;
  $data->{subject}      = $4;
  my $body = $5;

  my @lines = split /\n/, $body;
  foreach my $currLine (@lines) {
    $currLine = prepareMD($currLine);

    if ( $currLine !~ m{\A\s*\z} ) {
      push @{ $data->{body} }, $currLine;
    }
  }

  $data->{subject} = prepareMD( $data->{subject} );

  push @{ $vars->{logmessages} }, $data;
} #- foreach my $curr_hash (@commits)

my $template = <<EOT;
#Changelog for [% title %]

(on Branch: **[% branch %]**, since **[% startdate %]**)

-----------------------------------------------------------------
[% FOREACH msg IN logmessages -%]
 * **[% msg.subject %]** (via Commit [[% msg.hash.substr(0, 7) %]](https://github.com/hoppfrosch/AHK_EDE/commit/[% msg.hash %]))
[% FOREACH line IN msg.body %]   * [% IF (matches = line.match('INTERN')) -%]*[% END %][% line %][% IF (matches = line.match('INTERN')) -%]*[% END %]
[% END %][% END %]
EOT


my $html;
my $tt = Template->new();
$tt->process( \$template, $vars, \$html );

my $FH;
open $FH, ">", $outfile;
print $FH $html;
close $FH;

1;

sub prepareMD {
  my $inp = shift;

  # remove "[V]" from beginning of line
  $inp =~ s{\A\s*\[V\]\s*}{}i;

  # Dekodieren der Umlaute
  $inp =~ s{(ü)}{ue}g;
  $inp =~ s{(Ü)}{Ue}g;
  $inp =~ s{(ä)}{ae}g;
  $inp =~ s{(Ä)}{Ae}g;
  $inp =~ s{(ö)}{oe}g;
  $inp =~ s{(Ö)}{Oe}g;
  $inp =~ s{(ß)}{ss}g;

  # Leerzeichen bereinigen
  $inp =~ s{  }{ }g;
  $inp =~ s{ \z}{}g;

  # Bugreferenzen in Links umwandeln
  my $newLine = $inp;

  $newLine =~ s{\ACloses }{}i;
  while ( $inp =~ m{(#(\d+))}ig ) {
    my $source = $1;

    my $github_issue_link = "https://jira.vitronic.de:8443/browse/" . $source;
    my $dest     = "[".$source."](https://github.com/hoppfrosch/AHK_EDE/issues/".$2.")";

    $newLine =~ s{$source}{$dest};
  }
  $inp = $newLine;

  return $inp;

} #- sub prepareMD
