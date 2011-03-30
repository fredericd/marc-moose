package MARC::Moose::Formater::Legacy;
# ABSTRACT: Record formater into the legacy MARC::Record object

use namespace::autoclean;
use Moose;

extends 'MARC::Moose::Formater';

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;
use MARC::Record;


override 'format' => sub {
    my ($self, $record) = @_;

    my $marc = MARC::Record->new;
    $marc->leader( $record->leader );
    for my $field ( @{$record->fields} ) {
        $marc->append_fields(
            $field->tag < 10
            ? MARC::Field->new( $field->tag, $field->value )
            : MARC::Field->new( $field->tag, $field->ind1, $field->ind2, map { ($_->[0], $_->[1]) } @{$field->subf} )
        );
    }
    return $marc;
};

__PACKAGE__->meta->make_immutable;

1;
