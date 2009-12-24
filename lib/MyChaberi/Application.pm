package MyChaberi::Application;
use Any::Moose;

extends 'Tatsumaki::Application';

sub BUILD {
	my $self = shift;

	# XXX backword compatible 
	#     ( Tatsumaki b9161912b6fef4434a76fdcbca3d57ecea9cdbb7 )
	#     ( Tatsumaki 13eef7f7d4fb5b9141afc7f6d3ba3d8e800ccfd7 )
	$self->template->mt->{tag_start} = "<?";
	$self->template->mt->{tag_end} = "?>";
	$self->template->mt->{line_start} = "?";
}

__PACKAGE__->meta->make_immutable;
no  Any::Moose;
1;
