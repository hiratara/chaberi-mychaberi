package MyChaberi::ChatSearchHandler;
use Any::Moose;
use Encode;
use JSON;
use MyChaberi::Config;
use List::Util;

extends 'Tatsumaki::Handler';

sub get {
	my $self = shift;
	my $jsonfile = MyChaberi::Config->get->{members_file};
	my $json = JSON->new->utf8(0)->decode( do {
		local $/;
		open( my $fh, '<:utf8', $jsonfile );
		<$fh>;
	} );

	my $query = do{
		my $q = decode_utf8 $self->request->param( 'q' ) || '';
		qr/\Q$q\E/;
	};

	my @rooms;
	for my $p ( @{$json->{info}->{pages}} ){
		for my $r (@{$p->{rooms}}){
			my $text = join ' ', $p->{name}, $r->{name}, 
			                     map { $_->{name} } @{$r->{members}};

			# Do search
			next unless $text =~ $query;

			# Add the page name to the room name
			push @rooms, {%$r, name => $p->{name} . '/' . $r->{name} };
		}
	}

	# Shuffle to display any rooms.
	@rooms = List::Util::shuffle( @rooms );

	$self->render( 'search.html', {rooms => [grep $_, @rooms[0 .. 19]]} );
}

__PACKAGE__->meta->make_immutable;
no  Any::Moose;

1;
