package MyChaberi::ChatPostHandler;
use Any::Moose;
use utf8;
use Encode;
use MyChaberi::Channel;

extends 'Tatsumaki::Handler';

sub post {
    my $self = shift;
    my ( $channel ) = @_;

    my $comment = decode_utf8 $self->request->param( 'text' );

    # Send to chaberi server.
    my $chan = MyChaberi::Channel->instance( $channel );
    $chan->conn->say( $comment );

    # Send to client.
    # XXX Duplicated with Channel.pm
    $chan->mq->publish( {
        type    => 'said', 
        member  => $chan->conn->me,
        comment => $comment,
        color   => '#000000',  # XXX default values defined in AE::Chaberi
        size    => '2',        # XXX 
    } );

    $self->write({ success => 1 });
}

__PACKAGE__->meta->make_immutable;
no  Any::Moose;

1;
