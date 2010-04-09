package MyChaberi::ChatSearchHandler;
use Any::Moose;
use JSON;
use MyChaberi::Config;

extends 'Tatsumaki::Handler';

sub get {
	my $self = shift;
	my $jsonfile = MyChaberi::Config->get->{members_file};
	my $json = JSON->new->utf8(0)->decode( do {
		local $/;
		open( my $fh, '<:utf8', $jsonfile );
		<$fh>;
	} );

	my @rooms = map { @{$_->{rooms}} } map { @{$_->{pages}} } $json->{info};

	$self->render( 'search.html', {rooms => [grep $_, @rooms[0 .. 19]]} );
}

__PACKAGE__->meta->make_immutable;
no  Any::Moose;

1;
