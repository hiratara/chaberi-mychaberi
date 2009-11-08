package ChatPollHandler;
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


package ChatPostHandler;
use Moose;
use utf8;
use HTML::Entities;

extends 'Tatsumaki::Handler';

sub post {
    my $self = shift;
    my $req = $self->request;

    # XXX "room" should be connected by DI.
    $main::room->say( $req->param( 'text' ) );

    $self->write({ success => 1 });
}

__PACKAGE__->meta->make_immutable;
no  Moose;


package ChatRoomHandler;
use Moose;
use utf8;

extends 'Tatsumaki::Handler';

sub get {
    my $self = shift;
    $self->render( 'chat.html' );
}

__PACKAGE__->meta->make_immutable;
no  Moose;


package main;
use strict;
use warnings;
use utf8;

use Tatsumaki::Application;
use File::Basename;
use Chaberi::AnyEvent::Room;

# XXX Shouldn't be global variables.
our $room = Chaberi::AnyEvent::Room->new(
	address       => 'ch0.chaberi.com', 
	port          => '6899',
	on_connect    => sub {
		my $self = shift;
		warn "entering";
		$self->enter(
			room => '39',
			name => 'ゲスト39',
			id   => '2626790',
			hash => '11eb725d6a4dfc5e31eb8f773e637bbf',
		);
	},
	on_disconnect      => sub { warn "disconnected!"; },
	on_error           => sub { warn @_; },
	on_enter           => sub { warn "entered ... " . join ',', @_; },
	on_member_entered  => sub { warn "entered ... " . $_[0]; },
	on_member_leaving  => sub { warn "leaving ... " . $_[0]; },
	on_unknown_command => sub { use Data::Dumper; warn Dumper $_[0]; },
	on_said            => sub {
		my ($id, $comment) = @_;
		my $mq  = Tatsumaki::MessageQueue->instance( 'chaberi' );
		# warn "said ... " . join ',', @_;
		$mq->publish( {
			type => 'message',
			log  => $id . ':' . $comment,
		} );
	},
);

my $app = Tatsumaki::Application->new( [
	"/poll" => 'ChatPollHandler',
	"/post" => 'ChatPostHandler',
	"/"     => 'ChatRoomHandler',
] );

$app->template_path( (dirname __FILE__) . "/templates");
$app->static_path( (dirname __FILE__) . "/static");

$app;
