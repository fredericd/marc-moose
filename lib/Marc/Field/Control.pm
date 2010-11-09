package Marc::Field::Control;
# ABSTRACT: Control Marc field (tag < 010)

use namespace::autoclean;
use Moose;

extends 'Marc::Field';

has value => ( is => 'rw', isa => 'Str' );

override 'as_formatted' => sub {
    my $self = shift;

    join ' ', ( $self->tag, $self->value );
};

#__PACKAGE__->meta->make_immutable;

1;

