package MyChaberi::ChatRoomHandler;
use Moose;
use utf8;
use MyChaberi::Connection;

extends 'Tatsumaki::Handler';

sub get {
    my $self = shift;
    my ( $channel ) = @_;

    MyChaberi::Connection->connect(
        channel => $channel,
        address => 'ch0.chaberi.com', 
        port    => '6899',
        room    => '9',
        name    => 'ゲスト39',
        id      => '2626790',
        hash    => '11eb725d6a4dfc5e31eb8f773e637bbf',
    ) unless MyChaberi::Connection->instance;

    $self->render( 'chat.html' );
}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;

