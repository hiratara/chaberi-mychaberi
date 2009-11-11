package MyChaberi::Application;
use Moose;

extends 'Tatsumaki::Application';

sub BUILD {
	my $self = shift;

	# XXX backword compatible 
	#     ( Tatsumaki b9161912b6fef4434a76fdcbca3d57ecea9cdbb7 )
	$self->template->{tag_start} = "<?";
	$self->template->{tag_end} = "?>";
	$self->template->{line_start} = "?";
}

__PACKAGE__->meta->make_immutable;
no  Moose;
1;
