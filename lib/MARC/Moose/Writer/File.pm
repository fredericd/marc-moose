package MARC::Moose::Writer::File;
# ABSTRACT: File record writer

use namespace::autoclean;
use Moose;

use Carp;
use MARC::Moose::Record;

extends 'MARC::Moose::Writer';

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

has binmode => ( is => 'rw', isa => 'Str', default => '' );

sub BUILD {
    my $self = shift;
    my $fh = $self->fh;
    print $fh $self->formater->begin();
}


sub DEMOLISH {
    my $self = shift;
    my $fh = $self->fh;
    print $fh $self->formater->end();
}


override 'write' => sub {
    my ($self, $record) = @_;

    $self->count( $self->count + 1 );

    my $fh = $self->fh;
    print $fh $self->formater->format($record);
};

__PACKAGE__->meta->make_immutable;

1;


=attr file

Name of the file into which writing L<MARC::Moose::Record> records using
I<write> method.  Before writing into the file, record is formatted using a
formater.

=attr binmode

Binmode of the result file. Example:

 my $writer = MARC::Moose::Writer->new(
   binmode  => 'utf8',
   file     => 'output.iso2709',
   formater => MARC::Moose::Formater::Iso2709->new() );

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Writer>
