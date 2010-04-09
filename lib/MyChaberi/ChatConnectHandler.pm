package MyChaberi::ChatConnectHandler;
use Any::Moose;
use Encode;
use Chaberi::AnyEvent::RoomPage;

extends 'Tatsumaki::Handler';
with 'MyChaberi::Role::AbsoluteURL';

__PACKAGE__->asynchronous(1);

sub post {
	my $self = shift;
	my $req  = $self->request;
	my $res  = $self->response;

	# Load sockhost and sockport for the url
	( chaberi_room_page $req->param( 'url' ) )->cb(sub{
		my $parsed = $_[0]->recv;
		my $channel = MyChaberi::Channel->connect(
			address => $parsed->{host},
			room    => $parsed->{room_id},
			port    => $parsed->{port},
			map {
				$_ => decode_utf8 scalar $req->param( $_ ) 
			} qw/name id hash/,
		);

		$res->redirect( $self->abs_url( $channel ) );
		$self->finish;
	});
}

__PACKAGE__->meta->make_immutable;
no  Any::Moose;

1;
