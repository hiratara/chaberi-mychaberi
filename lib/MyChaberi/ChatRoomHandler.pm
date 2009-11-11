package MyChaberi::ChatRoomHandler;
use Moose;
use utf8;
use Try::Tiny;
use MyChaberi::Channel;

extends 'Tatsumaki::Handler';
with 'MyChaberi::Role::AbsoluteURL';

sub get {
    my $self = shift;
    my ( $channel ) = @_;

    try {
        my $chan = MyChaberi::Channel->instance( $channel ) or die;
        $self->render( 'chat.html' );
    } catch {
        qr/no connections/i or die;
        $self->response->redirect( $self->abs_url( '..' ) );
    };

}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;

