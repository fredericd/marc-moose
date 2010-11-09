package Marc::Writer::File;
# ABSTRACT: File Marc record writer

use namespace::autoclean;
use Moose;

use Carp;
use Marc::Record;

extends 'Marc::Writer';

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

Name of the file into which writing Marc::Record records using I<write> method.
Before writing into the file, record is formatted using a formater.

=attr binmode

Binmode of the result file. Example:

 my $writer = Marc::Writer->new(
   binmode  => 'utf8',
   file     => 'output.iso2709',
   formater => Marc::Formater::Iso2709->new() );

=head1 SEE ALSO

=for :list
* L<Marc>
* L<Marc::Writer>
