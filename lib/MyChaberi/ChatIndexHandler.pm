package MyChaberi::ChatIndexHandler;
use Any::Moose;

extends 'Tatsumaki::Handler';
with 'MyChaberi::Role::AbsoluteURL';

sub get {
	my $self = shift;

	$self->render( 'index.html' );
}

__PACKAGE__->meta->make_immutable;
no  Any::Moose;

1;
