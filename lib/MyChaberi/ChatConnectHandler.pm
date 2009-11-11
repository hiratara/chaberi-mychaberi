package MyChaberi::ChatConnectHandler;
use Moose;

extends 'Tatsumaki::Handler';
with 'MyChaberi::Role::AbsoluteURL';

__PACKAGE__->asynchronous(1);

sub post {
	my $self = shift;
	my $req  = $self->request;

	MyChaberi::Channel->connect(
		( map {
			$_ => scalar $req->param( $_ ) 
		} qw/address port room name id hash/ ),
		sub {
			my $chan = shift;
			$self->response->redirect( $self->abs_url( $chan->channel ) );
			$self->finish;
		},
	);
}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;
