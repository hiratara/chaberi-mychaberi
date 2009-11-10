package MyChaberi::ChatRoomHandler;
use Moose;
use utf8;

extends 'Tatsumaki::Handler';

sub get {
    my $self = shift;
    $self->render( 'chat.html' );
}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;

