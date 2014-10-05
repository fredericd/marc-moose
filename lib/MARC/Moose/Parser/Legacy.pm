package MARC::Moose::Parser::Legacy;
# ABSTRACT: Parser for MARC::Record legacy records

use Moose;

extends 'MARC::Moose::Parser';



override 'parse' => sub {
    my ($self, $legacy) = @_;

    return unless $legacy;

    my $record = MARC::Moose::Record->new();
    $record->_leader( $legacy->leader );
    my @fields;
    for my $field ( $legacy->fields() ) {
        my $tag = $field->tag;
        push @fields, $tag < '010'
            ? MARC::Moose::Field::Control->new(
                tag   => $tag,
                value => $field->data )
            : MARC::Moose::Field::Std->new(
                tag  => $tag,
                ind1 => $field->indicator(1),
                ind2 => $field->indicator(2), 
                subf => [ $field->subfields() ] )
    }
    $record->fields( \@fields );
    $record->lint($self->lint) if $self->lint;
    return $record;
};

__PACKAGE__->meta->make_immutable;

1;

=head1 SYNOPSYS

 # Get a MARC::Record
 my $legacy_record = GetMarcBiblio(100); 
 my $parser = MARC::Moose::Parser::Legacy->new();
 # Transform it into MARC::Moose::Record
 my $record = $parser->parse($legacy_record);

=head1 SEE ALSO
=for :list
* L<MARC::Moose>
* L<MARC::Moose::Parser>
* L<MARC::Record>
