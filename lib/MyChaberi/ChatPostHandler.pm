package MyChaberi::ChatPostHandler;
use Moose;
use utf8;
use MyChaberi::Channel;

extends 'Tatsumaki::Handler';

sub post {
    my $self = shift;
    my ( $channel ) = @_;

    my $req = $self->request;

    my $room = MyChaberi::Channel->instance( $channel )->conn;
    $room->say( $req->param( 'text' ) );

    $self->write({ success => 1 });
}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;
