package Marc::Reader::File;

use namespace::autoclean;
use Moose;

use Carp;
use Marc::Record;

extends 'Marc::Reader';

has file => (
    is => 'rw',
    isa => 'Str',
    trigger => sub {
        my ($self, $file) = @_; 
        unless ( -e $file ) { 
            croak "File doesn't exist: " . $file;
        }   
        $self->{file} = $file;
    }   
);

has fh => ( is => 'rw' );


sub BUILD {
    my $self = shift;

    open my $fh, '<',$self->file
         or croak "Impossible to open file: " . $self->file;
    $self->fh($fh);
}


sub read {
    my $self = shift;

    $self->SUPER::read();
}

__PACKAGE__->meta->make_immutable;

1;

