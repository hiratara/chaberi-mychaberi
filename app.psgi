use strict;
use warnings;
use utf8;

use Tatsumaki::Application;
use File::Basename;

use MyChaberi::ChatPollHandler;
use MyChaberi::ChatPostHandler;
use MyChaberi::ChatRoomHandler;

my $app = Tatsumaki::Application->new( [
	"/poll" => 'MyChaberi::ChatPollHandler',
	"/post" => 'MyChaberi::ChatPostHandler',
	"/"     => 'MyChaberi::ChatRoomHandler',
] );

$app->template_path( (dirname __FILE__) . "/templates");
$app->static_path( (dirname __FILE__) . "/static");

$app;
