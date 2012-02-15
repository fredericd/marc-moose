package MARC::Moose::Reader;
# ABSTRACT: Base class for a reader returning MARC::Moose records

use Moose;

=attr count

Number of records that have been read with L<read> method.

=cut

has count => (
    is => 'rw',
    isa => 'Int',
    default => 0
);


=attr parser

L<MARC::Moose::Parser> parser used to parse record that have been read.

=cut

has parser => (
    is => 'rw', isa => 'MARC::Moose::Parser',
);


=attr fh

A file handle from which reading records. This can be a string with:

  open my $fh, "<", \*str;

=cut

has fh => ( is => 'rw' );


=method read

Read one L<MARC::Moose::Record> record from the underlying data stream, and
return it. This base class return 1.

=cut

sub read {
    my $self = shift;

    $self->count( $self->count + 1 );

    return 1;
}

__PACKAGE__->meta->make_immutable;

1;

