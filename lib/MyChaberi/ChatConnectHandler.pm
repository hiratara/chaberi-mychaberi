package MyChaberi::ChatConnectHandler;
use Moose;

extends 'Tatsumaki::Handler';
with 'MyChaberi::Role::AbsoluteURL';

sub post {
	my $self = shift;
	my $req  = $self->request;
	my $res  = $self->response;

	my $channel = MyChaberi::Channel->connect(
		map {
			$_ => scalar $req->param( $_ ) 
		} qw/address port room name id hash/,
	);

	$res->redirect( $self->abs_url( $channel ) );
}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;
