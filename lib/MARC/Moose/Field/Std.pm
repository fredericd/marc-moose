package MARC::Moose::Field::Std;
# ABSTRACT: Standard Marc Field (tag >= 010)

use namespace::autoclean;
use Moose;

extends 'MARC::Moose::Field';

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

    return unless defined($letter);

    my @values;
    for ( @{$self->subf} ) {
        push @values, $_->[1] if $_->[0] eq $letter;
    }

    return unless @values;
    return wantarray ? @values : $values[0];
}

__PACKAGE__->meta->make_immutable;

1;

=method field( I<letter> )

In scalar context, returns the first I<letter> subfield content. In list
context, returns all I<letter> subfields content.

For example:

  my $field = MARC::Moose::Field::Std->new(
    tag => '600',
    subf => [
      [ a => 'Part 1' ],
      [ x => '2010' ],
      [ a => 'Part 2' ],
    ] );
  my $value = $field->subfield('a'); # Get 'Part 1'
  my @values = $field->subfield('a'); # Get ('Part1', 'Part 2')


