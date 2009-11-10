package MyChaberi::Connection;
use Moose;
use Tatsumaki::MessageQueue;
use Chaberi::AnyEvent::Room;
use Scalar::Util;

has conn    => ( is => 'ro', isa => 'Chaberi::AnyEvent::Room', required => 1 );
has channel => ( is => 'ro', isa => 'Int',                     required => 1 );

my %instance;
sub instance {
	my $class = shift;
	my ( $channel ) = @_;
	return $instance{$channel} or die 'No connections';
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
		on_disconnect      => sub { warn "disconnected!"; },
		on_error           => sub { warn @_; },
		on_enter           => sub { warn "entered ... " . join ',', @_; },
		on_member_entered  => sub { warn "entered ... " . $_[0]; },
		on_member_leaving  => sub { warn "leaving ... " . $_[0]; },
		on_unknown_command => sub { use Data::Dumper; warn Dumper $_[0]; },
#		on_said            => sub {},
	);

	return { conn => $conn, %params };
};


sub BUILD {
	Scalar::Util::weaken ( my $self = shift ); 

	$self->conn->on_said( sub {
		my ($member, $comment) = @_;
		$self->mq->publish( {
			type => 'message',
			log  => $member->{name} . ':' . $comment,
		} );
	} );
}


sub mq {
	my $self = shift;
	return Tatsumaki::MessageQueue->instance( 
			'chaberi' . $self->channel
	);
}

__PACKAGE__->meta->make_immutable;
no  Moose;
1;
