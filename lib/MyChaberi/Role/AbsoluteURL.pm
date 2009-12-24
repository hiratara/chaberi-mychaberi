package MyChaberi::Role::AbsoluteURL;
use Any::Moose '::Role';
use URI;

requires 'request';

sub abs_url {
	my $self = shift;
	my ( $rel_url ) = @_;
	my $req  = $self->request;

	return URI->new_abs( $rel_url, $req->uri )->as_string;
}

no  Any::Moose '::Role';
1;
