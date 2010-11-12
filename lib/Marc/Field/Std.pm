package Marc::Field::Std;
# ABSTRACT: Standard Marc Field (tag >= 010)

use namespace::autoclean;
use Moose;

extends 'Marc::Field';

use overload
    '%{}' => \&subfield;


has ind1 => (is => 'rw', isa => 'Str', default => ' ');
has ind2 => (is => 'rw', isa => 'Str', default => ' ');

has subf => ( is => 'rw', isa => 'ArrayRef', default => sub { [] } );


override 'as_formatted' => sub {
    my $self = shift;

    join ' ', (
        $self->tag,
        map { ("\$$_->[0]", $_->[1]) } @{$self->subf} );
};


sub subfield {
    my ($self, $letter) = @_;

    my @values;
    for ( @{$self->subf} ) {
        push @values, $_->[1] if $_->[0] eq $letter;
    }

    return wantarray ? @values : $values[0];
}

__PACKAGE__->meta->make_immutable;

1;

