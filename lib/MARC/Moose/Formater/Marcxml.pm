package MARC::Moose::Formater::Marcxml;
#ABSTRACT: MARC::Moose record formater into MARCXML

use Moose;

extends 'MARC::Moose::Formater';

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;
use XML::Writer;


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
        if ( ref($field) eq 'MARC::Moose::Field::Control' ) {
            $w->startTag( "controlfield", tag => $field->tag );
            $w->characters( $field->value );
            $w->endTag();
        }
        else {
            $w->startTag(
                "datafield", tag => $field->tag, ind1 => $field->ind1,
                ind2 => $field->ind2 );
            for ( @{$field->subf} ) {
                my ($letter, $value) = @$_;
                $w->startTag( "subfield", code => $letter );
                # FIXME: XML::Writer should escape 1B (ESC) character, but it doesn't
                $value =~ s/\x1B//g;
                $w->characters( $value );
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
