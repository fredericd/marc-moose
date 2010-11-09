package Marc::Reader;
# ABSTRACT: A reader returning Marc records

use namespace::autoclean;
use Moose;

has count => (
    is => 'rw',
    isa => 'Int',
    default => 0
);


has parser => (
    is => 'rw',
);


sub read {
    my $self = shift;

    $self->count( $self->count + 1 );

    return 1;
}

__PACKAGE__->meta->make_immutable;

1;

