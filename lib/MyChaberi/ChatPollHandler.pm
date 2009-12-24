package MyChaberi::ChatPollHandler;
use Any::Moose;
use utf8;
use Tatsumaki::Error;
use MyChaberi::Channel;

extends 'Tatsumaki::Handler';

__PACKAGE__->asynchronous(1);

sub get {
    my $self = shift;
    my ( $channel ) = @_;

    my $mq = MyChaberi::Channel->instance( $channel )->mq;
    my $session = $self->request->param('session')
                     or Tatsumaki::Error::HTTP->throw(500, "'session' needed");
    $mq->poll_once( $session, sub {
        $self->write( \@_ );
        $self->finish;
    });
}

__PACKAGE__->meta->make_immutable;
no  Any::Moose;

1;
