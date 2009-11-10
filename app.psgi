use strict;
use warnings;
use utf8;

use Tatsumaki::Application;
use File::Basename;
use Chaberi::AnyEvent::Room;

use MyChaberi::ChatPollHandler;
use MyChaberi::ChatPostHandler;
use MyChaberi::ChatRoomHandler;


# XXX Shouldn't be global variables.
$MyChaberi::ChatPostHandler::room = Chaberi::AnyEvent::Room->new(
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
		my ($member, $comment) = @_;
		my $mq  = Tatsumaki::MessageQueue->instance( 'chaberi' );
		# warn "said ... " . join ',', @_;
		$mq->publish( {
			type => 'message',
			log  => $member->{name} . ':' . $comment,
		} );
	},
);

my $app = Tatsumaki::Application->new( [
	"/poll" => 'MyChaberi::ChatPollHandler',
	"/post" => 'MyChaberi::ChatPostHandler',
	"/"     => 'MyChaberi::ChatRoomHandler',
] );

$app->template_path( (dirname __FILE__) . "/templates");
$app->static_path( (dirname __FILE__) . "/static");

$app;
