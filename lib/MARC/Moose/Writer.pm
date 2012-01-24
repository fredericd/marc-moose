package MARC::Moose::Writer;
# ABSTRACT: A base object to write somewhere MARC::Moose records

use namespace::autoclean;
use Moose;

=attr count

Number of records that have been written with L<write> method.

=cut

has count => (
    is      => 'rw',
    isa     => 'Int',
    default => 0
);


=attr formater

A L<MARC::Moose::Formater> to be used to format records to write. By defaut,
it's a L<MARC::Moose::Formater::Text> formater.

=cut

has formater => (
    is      => 'rw',
    isa     => 'MARC::Moose::Formater',
    default => sub { MARC::Moose::Formater::Text->new() }
);


=method begin

Method to be call before beginning writing record with L<write> method. By
default, this is just a call to the formater C<begin> method.

=cut

sub begin {
    my $self = shift;
    print $self->formater->begin();
}


=method end

Method to be call at the end of the writing process, afet the last record has
been written, the last call to L<write>. By default, this is just a call to the
formater C<end> method.

=cut

sub end {
    my $self = shift;
    print $self->formater->end();
}


=method write($record)

Write L<MARC::Moose::Record> $record into whatever data stream, a file, a
socket, etc. It uses the L<formater> to format the record. In this base class,
the record is printed on STDOUT.

=cut

sub write {
    my ($self, $record) = shift;

    $self->count( $self->count + 1 );

    print $self->formater->format($record);
}

__PACKAGE__->meta->make_immutable;

1;

