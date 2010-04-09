package MyChaberi::Config;
use YAML ();

my $settings;

sub load{
    my $class = shift;
    my ( $filepath ) = @_;
    $settings = YAML::LoadFile($filepath);
}

sub get{ $settings }

1;
