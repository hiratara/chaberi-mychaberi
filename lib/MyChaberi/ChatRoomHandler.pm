package MyChaberi::ChatRoomHandler;
use Moose;
use utf8;
use MyChaberi::Channel;

extends 'Tatsumaki::Handler';

sub get {
    my $self = shift;
    my ( $channel ) = @_;

    $self->render( 'chat.html' );
}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;

