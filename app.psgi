use strict;
use warnings;
use utf8;

use File::Basename;

use MyChaberi::Config;
use MyChaberi::Application;
use MyChaberi::ChatSearchHandler;
use MyChaberi::ChatEntranceHandler;
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
	"/entrance/(.*)"          => 'MyChaberi::ChatEntranceHandler',
	"/"                       => 'MyChaberi::ChatSearchHandler',
] );

$app->template_path( (dirname __FILE__) . "/templates");
$app->static_path( (dirname __FILE__) . "/static");
MyChaberi::Config->load( (dirname __FILE__) . "/config.yaml" );

$app;
