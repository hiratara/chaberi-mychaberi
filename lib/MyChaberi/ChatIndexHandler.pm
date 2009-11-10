package MyChaberi::ChatIndexHandler;
use Moose;

extends 'Tatsumaki::Handler';
with 'MyChaberi::Role::AbsoluteURL';

sub get {
	my $self = shift;

	$self->render( 'index.html' );
}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;
