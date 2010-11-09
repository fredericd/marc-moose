package Marc::Formater::Marcxml;
#ABSTRACT: Marc record formater into MARCXML

use namespace::autoclean;
use Moose;

extends 'Marc::Formater';

use Marc::Field::Control;
use Marc::Field::Std;
use XML::Writer 0.606;


override 'begin' => sub {
    return "<collection>\n";
};


override 'end' => sub {
    return "</collection>\n";
};


override 'format' => sub {
    my ($self, $record) = @_;

    my $str = '';
    my $w = XML::Writer->new( OUTPUT => \$str, DATA_MODE => 1, DATA_INDENT => 2 );

    $w->startTag( 'record' );
    $w->startTag( 'leader' );
    $w->characters( $record->leader );
    $w->endTag();

    for my $field ( @{$record->fields} ) {
        if ( ref($field) eq 'Marc::Field::Control' ) {
            $w->startTag( "controlfield", tag => $field->tag );
            $w->characters( $field->value );
            $w->endTag();
        }
        else {
            $w->startTag(
                "datafield", tag => $field->tag, ind1 => $field->ind1,
                ind2 => $field->ind2 );
            for my $sf ( @{$field->subf} ) {
                $w->startTag( "subfield", code => $sf->[0] );
                $w->characters( $sf->[1] );
                $w->endTag();
            }
            $w->endTag();
        }
    }
    $w->endTag();
    return $str . "\n";
};

__PACKAGE__->meta->make_immutable;

1;
