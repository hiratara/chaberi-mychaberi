package MyChaberi::ChatPostHandler;
use Moose;
use utf8;
use HTML::Entities;

extends 'Tatsumaki::Handler';

# XXX Hmm, "room" should be managed by some singleton manager classes.
our $room = undef;

sub post {
    my $self = shift;
    my $req = $self->request;

    $room->say( $req->param( 'text' ) );

    $self->write({ success => 1 });
}

__PACKAGE__->meta->make_immutable;
no  Moose;

1;
