package MyChaberi::ChatEntranceHandler;
use Any::Moose;

extends 'Tatsumaki::Handler';
with 'MyChaberi::Role::AbsoluteURL';

sub get {
	my $self = shift;

	$self->render( 'entrance.html' );
}

__PACKAGE__->meta->make_immutable;
no  Any::Moose;

1;
