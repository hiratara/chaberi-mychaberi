package MyChaberi::ChatMemberHandler;
use Any::Moose;
use utf8;
use MyChaberi::Channel;

extends 'Tatsumaki::Handler';

sub post {
    my $self = shift;
    my ( $channel ) = @_;

    my $chan = MyChaberi::Channel->instance( $channel );

    $self->write( [ values %{ $chan->conn->members } ] );
}

__PACKAGE__->meta->make_immutable;
no  Any::Moose;

1;
