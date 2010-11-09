package Marc::Writer;
# ABSTRACT: A base object to write somewhere Marc records

use namespace::autoclean;
use Moose;

has count => (
    is      => 'rw',
    isa     => 'Int',
    default => 0
);


has formater => (
    is      => 'rw',
    isa     => 'Marc::Formater',
    default => sub { Marc::Formater::Text->new() }
);


sub begin {
    my $self = shift;
    $self->parser->begin();
}


sub end {
    my $self = shift;
    $self->parser->end();
}


sub write {
    my ($self, $record) = shift;

    $self->count( $self->count + 1 );

    print $self->formater->format($record);
}

__PACKAGE__->meta->make_immutable;

1;

