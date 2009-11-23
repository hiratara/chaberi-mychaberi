use strict;
use warnings;
use utf8;

use File::Basename;

use MyChaberi::Application;
use MyChaberi::ChatIndexHandler;
use MyChaberi::ChatConnectHandler;
use MyChaberi::ChatDisconnectHandler;
use MyChaberi::ChatRoomHandler;
use MyChaberi::ChatPollHandler;
use MyChaberi::ChatPostHandler;
use MyChaberi::ChatMemberHandler;

my $chan_reg = '[1-9]\d*';
my $app = MyChaberi::Application->new( [
	"/poll/($chan_reg)"       => 'MyChaberi::ChatPollHandler',
	"/post/($chan_reg)"       => 'MyChaberi::ChatPostHandler',
	"/members/($chan_reg)"    => 'MyChaberi::ChatMemberHandler',
	"/disconnect/($chan_reg)" => 'MyChaberi::ChatDisconnectHandler',
	"/connect"                => 'MyChaberi::ChatConnectHandler',
	"/($chan_reg)"            => 'MyChaberi::ChatRoomHandler',
	"/"                       => 'MyChaberi::ChatIndexHandler',
] );

$app->template_path( (dirname __FILE__) . "/templates");
$app->static_path( (dirname __FILE__) . "/static");

$app;
