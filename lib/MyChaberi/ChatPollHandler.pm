package MyChaberi::ChatPollHandler;
use Moose;
use utf8;
use Tatsumaki::Error;
use Tatsumaki::MessageQueue;

extends 'Tatsumaki::Handler';

__PACKAGE__->asynchronous(1);

sub get {
    my $self = shift;
    my $mq = Tatsumaki::MessageQueue->instance( 'chaberi' );
    my $session = $self->request->param('session')
                     or Tatsumaki::Error::HTTP->throw(500, "'session' needed");
    $mq->poll_once( $session, sub {
        $self->write( \@_ );
        $self->finish;
    });
}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;
