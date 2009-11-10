use strict;
use warnings;
use utf8;

use Tatsumaki::Application;
use File::Basename;

use MyChaberi::ChatIndexHandler;
use MyChaberi::ChatConnectHandler;
use MyChaberi::ChatRoomHandler;
use MyChaberi::ChatPollHandler;
use MyChaberi::ChatPostHandler;

my $chan_reg = '[1-9]\d*';
my $app = Tatsumaki::Application->new( [
	"/poll/($chan_reg)" => 'MyChaberi::ChatPollHandler',
	"/post/($chan_reg)" => 'MyChaberi::ChatPostHandler',
	"/connect"          => 'MyChaberi::ChatConnectHandler',
	"/($chan_reg)"      => 'MyChaberi::ChatRoomHandler',
	"/"                 => 'MyChaberi::ChatIndexHandler',
] );

$app->template_path( (dirname __FILE__) . "/templates");
$app->static_path( (dirname __FILE__) . "/static");

$app;
