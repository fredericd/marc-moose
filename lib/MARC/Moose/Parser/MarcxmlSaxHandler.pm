package MARC::Moose::Parser::MarcxmlSaxHandler;
# ABSTRACT: SAX handler for parsing MARXML records

use strict;
use warnings;

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
    my $name = $element->{Name};
    $self->{data} = '';
    if ( $name eq 'record' ) {
        $self->{record} = MARC::Moose::Record->new();
        $self->{fields} = [];
    }
    elsif ( $name eq 'controlfield' ) {
        $self->{field} = MARC::Moose::Field::Control->new(
            tag => $element->{Attributes}{'{}tag'}{Value} );
    }
    elsif ( $name eq 'datafield' ) {
        my $attr = $element->{Attributes};
        $self->{field} = MARC::Moose::Field::Std->new(
            tag  => $attr->{'{}tag'}{Value},
            ind1 => $attr->{'{}ind1'}{Value} || '',
            ind2 => $attr->{'{}ind2'}{Value} || '',
        );
    }
    elsif ( $name eq 'subfield' ) {
        $self->{code} = $element->{Attributes}{'{}code'}{Value}
    }
}


sub end_element {
    my ($self, $element) = @_;
    my $name = $element->{Name};

    if ( $name eq 'leader' ) {
        my $record = $self->{record};
        $record->_leader( $self->{data} );
    }
    elsif ( $name eq 'controlfield' ) {
        my $field = $self->{field};
        $field->value( $self->{data} );
        push @{$self->{fields}}, $field;
    }
    elsif ( $name eq 'datafield' ) {
        push @{$self->{fields}}, $self->{field};
    }
    elsif ( $name eq 'subfield' ) {
        my $field = $self->{field};
        push @{$field->{subf}}, [ $self->{code}, $self->{data} ];
    }
    elsif ( $name eq 'record' ) {
        my $record = $self->{record};
        $record->fields( $self->{fields} );
    }
}


sub characters {
    my ($self, $characters) = @_;
    $self->{data} .= $characters->{Data};
}

1;

