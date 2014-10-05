package MARC::Moose::Parser;
# ABSTRACT: A record parser base class

use Moose;
use Modern::Perl;

# FIXME Experimental. Not used yet.
#has converter => (
#    is      => 'rw',
#    isa     => 'Text::IconvPtr',
#    default => sub { Text::Iconv->new( "cp857", "utf8" ) }
#);


=method lint

A <MARC::Moose::Lint::Checker> which is associated with parsed records. This
'lint' object is assigned to each record, so the 'check' method is available
for them: C<$record->check()>.

=cut
has lint => (is => 'rw', isa => 'MARC::Moose::Lint::Checker');


=method begin


=cut

sub begin {
    return "";
}


=method end


=cut

sub end {
    return "";
}


=method parse

Return a MARC::Moose::Record object build from a parsed string

=cut

sub parse {
    return MARC::Moose::Record->new();
};

__PACKAGE__->meta->make_immutable;

1;



=head1 SEE ALSO

=for :list
* L<MARC::Moose>
* L<MARC::Moose::Parser::Isis.pm
* L<MARC::Moose::Parser::Iso2709.pm
* L<MARC::Moose::Parser::Legacy.pm
* L<MARC::Moose::Parser::Marcxml.pm
* L<MARC::Moose::Parser::MarcxmlSax.pm
* L<MARC::Moose::Parser::MarcxmlSaxSimple.pm
* L<MARC::Moose::Parser::Yaml.pm

