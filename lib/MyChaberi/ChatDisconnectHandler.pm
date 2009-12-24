package MyChaberi::ChatDisconnectHandler;
use Any::Moose;

extends 'Tatsumaki::Handler';
with 'MyChaberi::Role::AbsoluteURL';

sub get {
	my $self = shift;
	my ( $channel ) = @_;

	MyChaberi::Channel->instance( $channel )->close;

	$self->response->redirect( $self->abs_url( '..' ) );
}

__PACKAGE__->meta->make_immutable;
no  Any::Moose;

1;
