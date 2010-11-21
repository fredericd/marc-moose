package MARC::Moose::Parser::MarcxmlSaxHandler;
# ABSTRACT: SAX handler for parsing MARXML records

use strict;
use warnings;
use feature ":5.10";

use XML::SAX;
use base qw( XML::SAX::Base );

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;


sub new {
    my $class = shift;
    return bless {}, ref($class) || $class;
}


sub start_element {
    my ($self, $element) = @_;
    $self->{data} = '';
    given ( $element->{LocalName} ) {
        when ( 'record' ) {
            $self->{record} = MARC::Moose::Record->new();
            $self->{fields} = [];
        }
        when ( 'controlfield' ) {
            $self->{field} = MARC::Moose::Field::Control->new(
                tag => $element->{Attributes}{'{}tag'}{Value} );
        }
        when ( 'datafield' ) {
            my $attr = $element->{Attributes};
            $self->{field} = MARC::Moose::Field::Std->new(
                tag  => $attr->{'{}tag'}{Value},
                ind1 => $attr->{'{}ind1'}{Value},
                ind2 => $attr->{'{}ind2'}{Value},
            );
        }
        when ( 'subfield' ) {
            $self->{code} = $element->{Attributes}{'{}code'}{Value}
        }
    }
}


sub end_element {
    my ($self, $element) = @_;
    given ( $element->{Name} ) {
        when ( 'leader' ) {
            my $record = $self->{record};
            $record->_leader( $self->{data} );
        }
        when ( 'controlfield' ) {
            my $field = $self->{field};
            $field->value( $self->{data} );
            push @{$self->{fields}}, $field;
        }
        when ( 'datafield' ) {
            push @{$self->{fields}}, $self->{field};
        }
        when ( 'subfield' ) {
            my $field = $self->{field};
            push @{$field->{subf}}, [ $self->{code}, $self->{data} ];
        }
        when ( 'record' ) {
            my $record = $self->{record};
            $record->fields( $self->{fields} );
        }
    }
}


sub characters {
    my ($self, $characters) = @_;
    $self->{data} .= $characters->{Data};
}

1;

