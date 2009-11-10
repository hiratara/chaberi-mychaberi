package MyChaberi::ChatConnectHandler;
use Moose;

extends 'Tatsumaki::Handler';
with 'MyChaberi::Role::AbsoluteURL';

sub post {
	my $self = shift;

	my $res  = $self->response;
	$res->redirect( $self->abs_url( '1' ) );  # XXX dummy channel
}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;
