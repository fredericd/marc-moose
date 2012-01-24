package MARC::Moose::Writer::File;
# ABSTRACT: File record writer

use namespace::autoclean;
use Moose;

use Carp;
use MARC::Moose::Record;

extends 'MARC::Moose::Writer';

=attr file

Name of the file into which writing L<MARC::Moose::Record> records using
I<write> method.  Before writing into the file, record is formatted using a
formater.

=cut

has file => (
    is => 'rw',
    isa => 'Str',
    trigger => sub {
        my ($self, $file) = @_; 
        #croak "File already exists: " . $file  if -e $file;
        $self->{file} = $file;
        open my $fh, '>',$self->file
            or croak "Impossible to open file: " . $self->file;
        binmode $fh, $self->binmode;
        $self->fh($fh);
    }   
);

has fh => ( is => 'rw' );

=attr binmode

Binmode of the result file. Example:

 my $writer = MARC::Moose::Writer::File->new(
   binmode  => 'utf8',
   file     => 'output.iso2709',
   formater => MARC::Moose::Formater::Iso2709->new() );

=cut

has binmode => ( is => 'rw', isa => 'Str', default => '' );


override 'begin' => sub {
    my $self = shift;
    my $fh = $self->fh;
    print $fh $self->formater->begin();
};


override 'end' => sub {
    my $self = shift;
    my $fh = $self->fh;
    print $fh $self->formater->end();
};


override 'write' => sub {
    my ($self, $record) = @_;

    $self->count( $self->count + 1 );

    my $fh = $self->fh;
    print $fh $self->formater->format($record);
};

__PACKAGE__->meta->make_immutable;

1;

=head1 DESCRIPTION

Override L<MARC::Moose::Writer>. Write record into a file.

