package MARC::Moose::Parser::Yaml;
# ABSTRACT: Parser for YAML records

use namespace::autoclean;
use Moose;

extends 'MARC::Moose::Parser';

use YAML::Syck;

$YAML::Syck::ImplicitUnicode = 1;

# FIXME Experimental. Not used yet.
#has converter => (
#    is      => 'rw',
#    isa     => 'Text::IconvPtr',
#    default => sub { Text::Iconv->new( "cp857", "utf8" ) }
#);



override 'parse' => sub {
    my ($self, $raw) = @_;

    #print "\nRAW: $raw\n";
    return unless $raw;
    return Load( $raw );
};

__PACKAGE__->meta->make_immutable;

1;

=head1 SEE ALSO
=for :list
* L<MARC::Moose>
* L<MARC::Moose::Parser>
