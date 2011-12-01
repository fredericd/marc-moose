package MARC::Moose::Parser::MarcxmlSaxSimple;
# ABSTRACT: Parser for MARXML records using SAX::Simple parser

use namespace::autoclean;
use Moose;

extends 'MARC::Moose::Parser';

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;
use XML::Simple;

has 'xs' => ( is => 'rw', default => sub {  XML::Simple->new() } );


override 'parse' => sub {
    my ($self, $raw) = @_;

    return unless $raw;

    my $ref = eval { $self->xs->XMLin($raw, forcearray => [ 'subfield' ] ) };
    return if $@;

    my $record = MARC::Moose::Record->new();
    $record->_leader( $ref->{leader} );
    my @fields_control = map {
        MARC::Moose::Field::Control->new( tag => $_->{tag}, value => $_->{content} );
    } @{$ref->{controlfield}};
    my @fields_std = map {
        my @sf = map { [ $_->{code}, $_->{content} ] }  @{$_->{subfield}};
        MARC::Moose::Field::Std->new(
            tag  => $_->{tag},
            ind1 => $_->{ind1},
            ind2 => $_->{ind2},
            subf => \@sf,
        ); 
    } @{$ref->{datafield}};
    $record->fields( [ @fields_control, @fields_std ] );

    return $record;
};

__PACKAGE__->meta->make_immutable;

1;

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Parser>
* L<MARC::Moose::Parser::Marcxml>
