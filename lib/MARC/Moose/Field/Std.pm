package MARC::Moose::Field::Std;
# ABSTRACT: Standard Marc Field (tag >= 010)

use Moose;

extends 'MARC::Moose::Field';

has ind1 => (is => 'rw', isa => 'Str', default => ' ');
has ind2 => (is => 'rw', isa => 'Str', default => ' ');


=attr subf

An ArrayRef of field subfields. Each subfield is this array is an 2D ArrayRef.
For example:

  $field->subf( [ [ 'a', 'Part1' ], [ 'b', 'Part2' ] ] );

or

  $field->subf( [ [ a => 'Part1' ], [ b => 'Part2' ] ] );

=cut
has subf => ( is => 'rw', isa => 'ArrayRef', default => sub { [] } );


override 'as_formatted' => sub {
    my $self = shift;

    join ' ', (
        $self->tag,
        $self->ind1 . $self->ind2,
        map { ("\$$_->[0]", $_->[1]) } @{$self->subf} );
};


override 'clone' => sub {
    my ($self, $tag) = @_;
    my $field = MARC::Moose::Field::Std->new( tag => $self->tag );
    $field->tag($tag) if $tag;
    $field->subf( [ map { $_ } @{$self->subf} ] );
    return $field;
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


