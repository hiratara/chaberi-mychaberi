package MyChaberi::Channel;
use Any::Moose;
use Encode;
use Tatsumaki::MessageQueue;
use Chaberi::AnyEvent::Room;
use Scalar::Util;

has conn    => ( 
	is => 'rw', isa => 'Maybe[Chaberi::AnyEvent::Room]', required => 1
);
has channel => ( is => 'ro', isa => 'Int',                     required => 1 );

my %instance;
sub instance {
	my $class = shift;
	my ( $channel ) = @_;
	return $instance{$channel} || die 'No connections';
}

my $channel = 0;
sub connect {
	my $class = shift;

	my $chan = ++$channel;
	$instance{ $chan } = $class->new( @_, channel => $chan, );

	return $chan;
}

sub channels {
	my $class = shift;
	return sort keys %instance;
}

around BUILDARGS => sub {
	my $orig  = shift;
	my $class = shift;
	my %params = @_;

	my $address = delete $params{address} 
	                                     or die q/address shouldn't be empty./;
	my $port    = delete $params{port}   or die q/port shouldn't be empty./;
	my $room    = delete $params{room}   or die q/room shouldn't be empty./;
	my $name    = delete $params{name}   or die q/name shouldn't be empty./;
	my $id      = delete $params{id}     or die q/id shouldn't be empty./;
	my $hash    = delete $params{hash}   or die q/hash shouldn't be empty./;

	my $conn = Chaberi::AnyEvent::Room->new(
		address       => $address, 
		port          => $port,
		on_connect    => sub {
			my $self = shift;

			$self->enter(
				room => $room,
				name => $name,
				id   => $id,
				hash => $hash,
			);
		},
		on_unknown_command => sub { use Data::Dumper; warn Dumper $_[0]; },
	);

	return { conn => $conn, %params };
};


sub BUILD {
	my $self = shift; 

	my $define_event = sub {
		my ( $type, $param_names ) = @_;

		grep {$_ eq 'type'} @$param_names and die;

		my $hook = "on_$type";
		$self->conn->$hook( sub {
			my %json; @json{ 'type', @$param_names } = ( $type, @_ );
			$self->mq->publish( \%json );
		} );
	};

	# Event definitions
	$define_event->('said'              , [qw(member comment color size)]);
	$define_event->('enter'             , [qw(sockid chatid hash)]);
	$define_event->('member_entered'    , [qw(member)]);
	$define_event->('member_statchanged', [qw(member stat oldstat)]);
	$define_event->('member_namechanged', [qw(member name oldname)]);
	$define_event->('owner_changed'     , [qw(owner oldowner)]);
	$define_event->('member_facechanged', [qw(member face oldface)]);
	$define_event->('member_leaving'    , [qw(member)]);
	$define_event->('member_kicked'     , [qw(member kicker)]);

	# Unknown tag
	$self->conn->on_unknown_command( sub {
		my $data = shift;

		# Drop utf-8 flags
		if( my ($attrs) = (values %$data) ){
			$_ = encode_utf8 $_ for values %$attrs;
		}

		require Data::Dumper;
		local $Data::Dumper::Indent = 0;
		$self->mq->publish({
			type => 'unknwon_command', 
			data => decode_utf8 Data::Dumper::Dumper( $data ),
		});
	} );

	$self->conn->on_disconnect( sub { 
		my $conn = shift;
		$self->mq->publish( { type => 'disconnect', } );
		$self->conn(undef);
		undef $self;  # break cyclic reference
	} );

	$self->conn->on_error( sub { 
		my @messages = @_;
		$self->mq->publish( { type => 'error', messages => \@messages, } );
	} );
}


sub mq {
	my $self = shift;
	return Tatsumaki::MessageQueue->instance( 
			'chaberi' . $self->channel
	);
}


sub close {
	my $self = shift;

	delete $instance{ $self->channel };
	$self->conn->shutdown if $self->conn;

	# XXX Should I forbid to call another method after this ?
}


__PACKAGE__->meta->make_immutable;
no  Any::Moose;
1;
