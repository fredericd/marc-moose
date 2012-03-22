package MARC::Moose::Field::Control;
# ABSTRACT: Control Marc field (tag < 010)

use Moose;

extends 'MARC::Moose::Field';

has value => ( is => 'rw', isa => 'Str' );

override 'as_formatted' => sub {
    my $self = shift;

    join ' ', ( $self->tag, $self->value );
};


override 'clone' => sub {
    my ($self, $tag) = @_;
    my $field = MARC::Moose::Field::Control->new( tag => $self->tag );
    $field->tag($tag) if $tag;
    my $value = $self->value . '';
    $field->value($value);
    return $field;
};


__PACKAGE__->meta->make_immutable;

1;

