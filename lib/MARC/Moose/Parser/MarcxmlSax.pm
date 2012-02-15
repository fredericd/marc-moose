package MARC::Moose::Parser::MarcxmlSax;
# ABSTRACT: Parser for MARXML records using SAX parser

use Moose;

extends 'MARC::Moose::Parser';

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;
use MARC::Moose::Parser::MarcxmlSaxHandler;
use XML::SAX qw(Namespaces Validation);;
use YAML;


has parser => (
    is => 'rw',
    default => sub {
        my $self = shift;
        my $factory = XML::SAX::ParserFactory->new();
        my $parser = $factory->parser(
            Handler => MARC::Moose::Parser::MarcxmlSaxHandler->new(),
        );
        $self->parser( $parser );
    },
);


override 'parse' => sub {
    my ($self, $raw) = @_;

    return unless $raw;

    $self->parser->parse_string( $raw );
    my $record = $self->parser->{Handler}->{record};
    return $record;
};

__PACKAGE__->meta->make_immutable;

1;


=head1 DESCRIPTION

Parser for MARCXML records using SAX parser.

=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Parser>
* L<MARC::Moose::Parser::Marcxml>
