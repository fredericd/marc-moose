package MARC::Moose::Field;
# ABSTRACT: Marc field base object

use namespace::autoclean;
use Moose;
use Moose::Util::TypeConstraints;

subtype 'Tag'
    => as 'Str'
    => where { $_ =~ /^\d{3}$/ }
    => message { 'A 3 digit is required' };

=attr tag

3-digits identifing a field. Required.

=cut
has tag => ( is => 'rw', isa => 'Tag', required => 1, );


=method clone([$tag])

Return a new field cloning the field. If tag is provided, the cloned field tag
is changed.

=cut
sub clone {
    my ($self, $tag) = @_;

    my $field = MARC::Moose::Field->new( tag => $self->tag );
    $field->tag($tag) if $tag;
    return $field;
}


sub as_formatted {
    my $self = shift;
    return $self->tag;
}

__PACKAGE__->meta->make_immutable;

1;

=head1 SEE ALSO

=for :list

* L<MARC::Moose::Field::Control>
* L<MARC::Moose::Field::Std>

