package MARC::Moose::Formater::Legacy;
# ABSTRACT: Record formater into the legacy MARC::Record object

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
        my $nfield;
        if ( $field->tag < 10 ) {
            my $value = $field->value;
            $nfield =  MARC::Field->new( $field->tag, $field->value );
        }
        else {
            my @sf;
            for (@{$field->subf}) {
                my ($letter, $value) = @$_;
                push @sf, $letter, $value if defined $value;
            }
            $nfield = MARC::Field->new(
                $field->tag,
                (defined $field->ind1 ) ? $field->ind1 : ' ',
                (defined $field->ind2 ) ? $field->ind2 : ' ', @sf ) if @sf;
        }
        $marc->append_fields($nfield) if $nfield;
    }
    return $marc;
};

__PACKAGE__->meta->make_immutable;
1;
